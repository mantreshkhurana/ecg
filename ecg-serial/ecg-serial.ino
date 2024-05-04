void setup() {
  pinMode(8,INPUT);
  pinMode(9,INPUT);

}

void loop() {
  Serial.begin(9600);
  if((digitalRead(8)==1)||(digitalRead(9)==1)){
      Serial.println("");
  }
  else{
      Serial.println(analogRead(A0));
  }
  delay(100);
  Serial.end();
  delay(100);
}
