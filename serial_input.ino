#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// Set LCD address (usually 0x27 or 0x3F)
LiquidCrystal_I2C lcd(0x27, 16, 2);

String inputString = "";

void setup() {
  Serial.begin(9600);

  lcd.init();          
  lcd.backlight();     

  lcd.setCursor(0, 0);
  lcd.print("Waiting Data...");
}

void loop() {
  while (Serial.available()) {
    char incomingChar = Serial.read();

    if (incomingChar == '\n') {
      lcd.clear();

      lcd.setCursor(0, 0);
      lcd.print("Received:");

      lcd.setCursor(0, 1);
      lcd.print(inputString);

      inputString = ""; // clear for next input
    } 
    else {
      inputString += incomingChar;
    }
  }
}