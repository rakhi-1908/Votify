import os
import sys
import time

# Windows console settings
os.environ["PYTHONUTF8"] = "1"
os.environ["PYTHONIOENCODING"] = "utf-8"
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

import cv2
import serial
from deepface import DeepFace
from supabase import create_client, Client


# ============================================================
# CONFIGURATION
# ============================================================
SERIAL_PORT = "COM3"
BAUD_RATE = 115200
CAMERA_INDEX = 0
REFERENCE_IMAGE = r"rakhi.jpg"
MODEL_NAME = "VGG-Face"
VERIFY_INTERVAL = 1.0
COOLDOWN = 5.0
VOTE_TIMEOUT = 60.0
CONFIRMATION_TIMEOUT = 10.0
RECORDED_DISPLAY_TIME = 2.0

# --- SUPABASE CONFIGURATION ---
SUPABASE_URL = "https://arqbqmussmkdglmufdjj.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFycWJxbXVzc21rZGdsbXVmZGpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxNTM2OTYsImV4cCI6MjA4ODcyOTY5Nn0.GI34_5gOYstXe7vESUczrBufWry4-oo5u0WXCG6cYdg"

# Change candidate names here. Keys remain 1, 2, 3 and 4.
CANDIDATES = {
    "1": "Candidate 1",
    "2": "Candidate 2",
    "3": "Candidate 3",
    "4": "Candidate 4",
}

VOTE_CONFIRMATIONS = {"VOTE_COMPLETE", "VOTE_RECORDED", "VOTE_OK"}
IDLE = "IDLE"
VOTING = "VOTING"
WAITING_FOR_CONFIRMATION = "WAITING_FOR_CONFIRMATION"
VOTE_RECORDED = "VOTE_RECORDED"


def safe_print(message):
    try:
        print(str(message))
    except Exception:
        try:
            print(str(message).encode("ascii", "replace").decode("ascii"))
        except Exception:
            pass


def init_supabase():
    try:
        client = create_client(SUPABASE_URL, SUPABASE_KEY)
        safe_print("[SUPABASE] Connected successfully.")
        return client
    except Exception as e:
        safe_print("[SUPABASE ERROR] Could not initialize: " + str(e))
        return None


def log_to_supabase(supabase, voter_status, candidate_name=None):
    if supabase is None:
        return
    try:
        data = {
            "voter_status": voter_status,
            "candidate_choice": candidate_name if candidate_name else "N/A",
        }
        supabase.table("booth_activity").insert(data).execute()
        safe_print("[SUPABASE LOGGED] " + voter_status + " | Choice: " + str(candidate_name))
    except Exception as error:
        safe_print("[SUPABASE INSERT ERROR] " + str(error))


def load_face_detector():
    cascade_path = cv2.data.haarcascades + "haarcascade_frontalface_default.xml"
    detector = cv2.CascadeClassifier(cascade_path)
    if detector.empty():
        safe_print("[ERROR] Could not load OpenCV face detector.")
        return None
    return detector


def find_face(image, detector):
    if image is None:
        return None

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    gray = cv2.equalizeHist(gray)
    faces = detector.detectMultiScale(
        gray,
        scaleFactor=1.1,
        minNeighbors=5,
        minSize=(80, 80),
    )
    if len(faces) == 0:
        return None

    x, y, width, height = max(
        faces,
        key=lambda rectangle: rectangle[2] * rectangle[3],
    )
    padding = int(0.25 * max(width, height))
    x1 = max(0, x - padding)
    y1 = max(0, y - padding)
    x2 = min(image.shape[1], x + width + padding)
    y2 = min(image.shape[0], y + height + padding)
    return image[y1:y2, x1:x2]


def send_node_command(esp, command):
    try:
        if esp is None or not esp.is_open:
            safe_print("[ERROR] NodeMCU is not connected.")
            return False
        esp.write((command.strip() + "\n").encode("utf-8"))
        esp.flush()
        safe_print("[PYTHON -> NODEMCU] " + command)
        return True
    except Exception as error:
        safe_print("[SERIAL WRITE ERROR] " + str(error))
        return False


def read_node_messages(esp):
    messages = []
    if esp is None or not esp.is_open:
        return messages

    try:
        while esp.in_waiting:
            message = esp.readline().decode("utf-8", errors="replace").strip()
            if message:
                messages.append(message)
                safe_print("[NODEMCU -> PYTHON] " + message)
    except Exception as error:
        safe_print("[SERIAL READ ERROR] " + str(error))
    return messages


def draw_text(frame, text, position, color, scale=0.7, thickness=2):
    cv2.putText(
        frame,
        text,
        position,
        cv2.FONT_HERSHEY_SIMPLEX,
        scale,
        color,
        thickness,
        cv2.LINE_AA,
    )


def draw_interface(frame, state, candidate_key=None, error_text=""):
    height, width = frame.shape[:2]
    white = (255, 255, 255)
    green = (0, 220, 0)
    yellow = (0, 220, 255)
    red = (0, 0, 255)

    if state == VOTING:
        cv2.rectangle(frame, (15, 15), (width - 15, height - 15), (25, 25, 25), -1)
        draw_text(frame, "CAST YOUR VOTE", (35, 60), green, 1.0, 2)
        y = 115
        for key, name in CANDIDATES.items():
            draw_text(frame, "[" + key + "] " + name, (45, y), white, 0.8, 2)
            y += 48
        draw_text(frame, "Press 1, 2, 3 or 4 to vote", (35, height - 55), yellow, 0.65, 2)
        draw_text(frame, "Press Q to cancel", (35, height - 25), white, 0.55, 1)
        return

    if state == WAITING_FOR_CONFIRMATION:
        draw_text(frame, "VOTE SELECTED: " + CANDIDATES[candidate_key], (30, 55), green, 0.7, 2)
        draw_text(frame, "VOTE SENT", (30, 100), yellow, 0.9, 2)
        draw_text(frame, "WAITING FOR VOTE RECORDED...", (30, 140), white, 0.65, 2)
    elif state == VOTE_RECORDED:
        draw_text(frame, "VOTE RECORDED", (30, 60), green, 0.95, 2)
        draw_text(frame, "THANK YOU", (30, 110), white, 0.8, 2)
    elif error_text:
        draw_text(frame, error_text, (30, 55), red, 0.7, 2)
    else:
        draw_text(frame, "FACE VERIFICATION", (30, 55), white, 0.85, 2)
        draw_text(frame, "LOOK AT THE CAMERA", (30, 100), yellow, 0.7, 2)

    draw_text(frame, "NodeMCU: " + SERIAL_PORT, (30, height - 45), white, 0.55, 1)
    draw_text(frame, "Press Q to quit", (30, height - 20), white, 0.55, 1)


safe_print("")
safe_print("==============================================")
safe_print("       VOTIFY FACE + KEYPAD SYSTEM")
safe_print("==============================================")
safe_print("")

esp = None
camera = None
supabase = None

try:
    supabase = init_supabase()

    if not os.path.isfile(REFERENCE_IMAGE):
        safe_print("[ERROR] Reference image does not exist:")
        safe_print(REFERENCE_IMAGE)
        sys.exit(1)

    safe_print("[SYSTEM] Loading rakhi.jpg...")
    reference_image = cv2.imread(REFERENCE_IMAGE)
    if reference_image is None:
        safe_print("[ERROR] OpenCV could not read rakhi.jpg.")
        sys.exit(1)

    face_detector = load_face_detector()
    if face_detector is None:
        sys.exit(1)

    reference_face = find_face(reference_image, face_detector)
    if reference_face is None:
        safe_print("[ERROR] NO FACE FOUND IN rakhi.jpg")
        sys.exit(1)

    reference_face_path = os.path.join(
        os.path.dirname(REFERENCE_IMAGE),
        "reference_face.jpg",
    )
    cv2.imwrite(reference_face_path, reference_face)
    safe_print("[SYSTEM] Reference face saved.")

    safe_print("[SYSTEM] Connecting to NodeMCU...")
    esp = serial.Serial(
        port=SERIAL_PORT,
        baudrate=BAUD_RATE,
        timeout=0,
        write_timeout=1,
    )
    time.sleep(2)
    esp.reset_input_buffer()
    safe_print("[SYSTEM] Connected to NodeMCU on " + SERIAL_PORT)

    camera = cv2.VideoCapture(CAMERA_INDEX)
    if not camera.isOpened():
        safe_print("[ERROR] Camera could not be opened.")
        sys.exit(1)
    safe_print("[SYSTEM] Camera opened.")

    safe_print("[SYSTEM] Initializing DeepFace...")
    DeepFace.verify(
        img1_path=reference_face,
        img2_path=reference_face,
        model_name=MODEL_NAME,
        detector_backend="skip",
        enforce_detection=False,
        align=False,
    )
    safe_print("[SYSTEM] DeepFace initialized successfully.")

    state = IDLE
    candidate_key = None
    state_started = time.time()
    last_verification = 0.0
    last_verified_time = 0.0
    error_text = ""

    while True:
        success, frame = camera.read()
        if not success:
            safe_print("[ERROR] Camera frame not received.")
            break

        now = time.time()
        messages = read_node_messages(esp)

        if state == WAITING_FOR_CONFIRMATION:
            if any(message in VOTE_CONFIRMATIONS for message in messages):
                state = VOTE_RECORDED
                state_started = now
                safe_print("[SYSTEM] VOTE RECORDED")
                # Log confirmed vote to Supabase
                selected_candidate = CANDIDATES.get(candidate_key, "Unknown")
                log_to_supabase(supabase, "VOTE_RECORDED", selected_candidate)
            elif now - state_started >= CONFIRMATION_TIMEOUT:
                send_node_command(esp, "VOTE_CANCEL")
                selected_candidate = CANDIDATES.get(candidate_key, "Unknown")
                log_to_supabase(supabase, "CONFIRMATION_TIMEOUT", selected_candidate)
                state = IDLE
                candidate_key = None
                error_text = "VOTE CONFIRMATION TIMEOUT"
                state_started = now

        elif state == VOTE_RECORDED:
            if now - state_started >= RECORDED_DISPLAY_TIME:
                state = IDLE
                candidate_key = None
                error_text = ""
                last_verification = now
                last_verified_time = now

        elif state == VOTING and now - state_started >= VOTE_TIMEOUT:
            send_node_command(esp, "VOTE_CANCEL")
            state = IDLE
            candidate_key = None
            error_text = "VOTING TIMEOUT"
            state_started = now
            log_to_supabase(supabase, "VOTING_TIMEOUT")

        camera_face = find_face(frame, face_detector)
        if camera_face is not None:
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            faces = face_detector.detectMultiScale(
                gray,
                scaleFactor=1.1,
                minNeighbors=5,
                minSize=(80, 80),
            )
            if len(faces) > 0:
                x, y, width, height = max(
                    faces,
                    key=lambda rectangle: rectangle[2] * rectangle[3],
                )
                cv2.rectangle(frame, (x, y), (x + width, y + height), (0, 255, 0), 2)

        if (
            state == IDLE
            and camera_face is not None
            and now - last_verification >= VERIFY_INTERVAL
            and now - last_verified_time >= COOLDOWN
        ):
            last_verification = now
            try:
                result = DeepFace.verify(
                    img1_path=reference_face,
                    img2_path=camera_face,
                    model_name=MODEL_NAME,
                    detector_backend="skip",
                    enforce_detection=False,
                    align=False,
                )
                if bool(result.get("verified", False)):
                    safe_print("[MATCH] Face Recognized!")
                    if send_node_command(esp, "VERIFY"):
                        state = VOTING
                        state_started = now
                        candidate_key = None
                        error_text = ""
                        last_verified_time = now
                        log_to_supabase(supabase, "FACE_VERIFIED")
                else:
                    safe_print("[NO MATCH] Face not recognized.")
            except Exception as error:
                error_text = "VERIFICATION ERROR"
                safe_print("[DeepFace ERROR] " + str(error))

        key_code = cv2.waitKey(1) & 0xFF
        if key_code == ord("q"):
            if state in (VOTING, WAITING_FOR_CONFIRMATION):
                send_node_command(esp, "VOTE_CANCEL")
                safe_print("[SYSTEM] Voting cancelled.")
                selected_candidate = CANDIDATES.get(candidate_key) if candidate_key else None
                log_to_supabase(supabase, "VOTING_CANCELLED", selected_candidate)
                state = IDLE
                candidate_key = None
                error_text = "VOTING CANCELLED"
                state_started = now
            else:
                break
        elif state == VOTING and key_code in (ord("1"), ord("2"), ord("3"), ord("4")):
            candidate_key = chr(key_code)
            if send_node_command(esp, "VOTE:" + candidate_key):
                state = WAITING_FOR_CONFIRMATION
                state_started = now
                log_to_supabase(
                    supabase,
                    "VOTE_SUBMITTED",
                    CANDIDATES[candidate_key],
                )

        draw_interface(frame, state, candidate_key, error_text)
        cv2.imshow("Votify Face Verification", frame)

except KeyboardInterrupt:
    safe_print("[SYSTEM] Program interrupted.")
except Exception as error:
    safe_print("[SYSTEM ERROR] " + str(error))
finally:
    safe_print("[SYSTEM] Closing camera...")
    if camera is not None:
        camera.release()
    cv2.destroyAllWindows()
    safe_print("[SYSTEM] Closing NodeMCU...")
    if esp is not None and esp.is_open:
        esp.close()
    safe_print("[SYSTEM] Program Closed.")