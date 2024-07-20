#include <Arduino.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <SoftwareSerial.h>

const int ecgPin = A0;
const int leadOffPin1 = 8;
const int leadOffPin2 = 9;
const int buzzerPin = 10;
const int rxPin = 11;
const int txPin = 12;

LiquidCrystal_I2C lcd(0x27, 16, 2);
SoftwareSerial bluetooth(rxPin, txPin);

void setup()
{

  Serial.begin(9600);
  bluetooth.begin(9600);

  pinMode(leadOffPin1, INPUT);
  pinMode(leadOffPin2, INPUT);
  pinMode(buzzerPin, OUTPUT);

  lcd.begin();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Heart Rate:");
}

void loop()
{

  bool leadOffDetected = (digitalRead(leadOffPin1) == HIGH) || (digitalRead(leadOffPin2) == HIGH);

  if (leadOffDetected)
  {

    Serial.println("!");
    digitalWrite(buzzerPin, HIGH);
    lcd.setCursor(0, 1);
    lcd.print("Leads off!     ");
    bluetooth.println("Leads off!");
  }
  else
  {

    int ecgValue = analogRead(ecgPin);
    Serial.println(ecgValue);
    bluetooth.println(ecgValue);

    lcd.setCursor(0, 1);
    lcd.print("HR: ");
    lcd.print(ecgValue);

    if (ecgValue > 900 || ecgValue < 100)
    {
      digitalWrite(buzzerPin, HIGH);
      lcd.setCursor(8, 1);
      lcd.print("Abnormal ");
    }
    else
    {
      digitalWrite(buzzerPin, LOW);
      lcd.setCursor(8, 1);
      lcd.print("Normal    ");
    }
  }
  delay(100);
}