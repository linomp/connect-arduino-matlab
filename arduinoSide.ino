int Vo; 

void setup() {
  Serial.begin(9600); 
}

void loop() { 
  Vo = analogRead(A0); // CONECTAR SENSOR ANÁLOGO AL PUERTO A0
  // SOLO IMPRIMIR DATOS CADA 1 SG.  
  if(millis() % 1000 == 0){
    Serial.print(millis());    
    Serial.print('\t');
    Serial.println(Vo);
  } 
}
