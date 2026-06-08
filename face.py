import cv2
from deepface import DeepFace
import serial
import time

# =========================
# NODEMCU CONNECTION
# =========================
try:
    esp = serial.Serial("COM4", 115200, timeout=1)
    time.sleep(2)
    print("[SYSTEM] Connected to NodeMCU on COM4")
except Exception as e:
    print("[ERROR] NodeMCU connection failed:", e)
    exit()

# =========================
# CAMERA SETUP
# =========================
video_capture = cv2.VideoCapture(0)

if not video_capture.isOpened():
    print("[ERROR] Camera not opening")
    exit()

print("[SYSTEM] Face Verification Started")

# =========================
# VARIABLES
# =========================
last_time = 0
cooldown = 5  # seconds between triggers

# =========================
# MAIN LOOP
# =========================
while True:

    ret, frame = video_capture.read()

    if not ret:
        print("[ERROR] Frame not received")
        break

    try:
        current_time = time.time()

        result = DeepFace.verify(
            img1_path="rakhi.jpg",
            img2_path=frame,
            enforce_detection=False,
            model_name="VGG-Face"
        )

        # =========================
        # FIXED MATCH BLOCK
        # =========================
        if result["verified"]:

            # prevent spam triggers
            if current_time - last_time > cooldown:

                print("[MATCH] Face Recognized!")

                esp.write(b"VERIFY\n")

                print("[SENT TO NODEMCU]")

                last_time = current_time

    except Exception as e:
        print("[DeepFace ERROR]", e)

    cv2.imshow("Votify Face Verification", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# =========================
# CLEANUP
# =========================
video_capture.release()
cv2.destroyAllWindows()

if esp.is_open:
    esp.close()

print("[SYSTEM] Program Closed")