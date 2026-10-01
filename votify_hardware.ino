#include <WiFi.h>
#include <HTTPClient.h>
#include <WebServer.h>
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"

// --- 1. CONFIGURATION ---
const char* ssid = "Wokwi-GUEST"; 
const char* password = ""; 

const char* supabase_url = "https://arqbqmussmkdglmufdjj.supabase.co/rest/v1/booth_activity";
const char* supabase_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFycWJxbXVzc21rZGdsbXVmZGpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxNTM2OTYsImV4cCI6MjA4ODcyOTY5Nn0.GI34_5gOYstXe7vESUczrBufWry4-oo5u0WXCG6cYdg";

// --- 2. OBJECTS & VARIABLES ---
WebServer server(80);
bool isVerified = false;
unsigned long verificationTime = 0;
int currentBoothID = 101;

// Function Prototype
void sendToSupabase(String eventType, String details);

void setup() {
  // 1. STOPS BOOT LOOP CRASHES (Power management)
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0); 
  
  Serial.begin(115200);
  Serial.setTimeout(50);
  delay(1000);
  Serial.println("\n--- Votify System Booting ---");

  // 2. WIFI CONNECTION
  WiFi.begin(ssid, password);
  Serial.println("WiFi connection started; serial voting remains available offline.");

  // 3. WEB SERVER ROUTE: Listen for your Python AI signal
  server.on("/verify", HTTP_GET, []() {
    isVerified = true;
    verificationTime = millis();
    server.send(200, "text/plain", "Hardware Unlocked");
    Serial.println("\n[!] AI SIGNAL RECEIVED: Voter Verified.");
    sendToSupabase("AI Face Recognition", "Verified: Rakhi");
  });

  server.begin();
  Serial.println("System Online. Waiting for Python Bridge on Port 8080...");
}

void handleSerialCommand() {
  if (!Serial.available()) {
    return;
  }

  String command = Serial.readStringUntil('\n');
  command.trim();

  if (command == "VERIFY") {
    isVerified = true;
    verificationTime = millis();
    Serial.println("VERIFIED");
  } else if (command.startsWith("VOTE:")) {
    bool sessionActive = isVerified && (millis() - verificationTime <= 90000);
    bool validCandidate = command.length() == 6 && command.charAt(5) >= '1' && command.charAt(5) <= '4';

    if (sessionActive && validCandidate) {
      isVerified = false;
      Serial.println("VOTE_RECORDED");
    } else {
      Serial.println("VOTE_REJECTED");
    }
  } else if (command == "VOTE_CANCEL") {
    isVerified = false;
    Serial.println("VOTE_CANCELLED");
  }
}

void loop() {
  server.handleClient();
  handleSerialCommand();

  if (isVerified && (millis() - verificationTime > 90000)) {
    isVerified = false;
    Serial.println("Session Expired. System Relocked.");
  }

  delay(10);
}

// --- SUPABASE UPDATE FUNCTION ---
void sendToSupabase(String eventType, String details) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(supabase_url);
    http.addHeader("Content-Type", "application/json");
    http.addHeader("apikey", supabase_key);
    http.addHeader("Authorization", "Bearer " + String(supabase_key));

    String jsonPayload = "{\"booth_id\": " + String(currentBoothID) + 
                         ", \"event_type\": \"" + eventType + 
                         "\", \"details\": \"" + details + "\"}";

    int httpResponseCode = http.POST(jsonPayload);
    Serial.print("Supabase Response: ");
    Serial.println(httpResponseCode);
    http.end();
  } else {
    Serial.println("Supabase Error: WiFi Disconnected");
  }
}