/*
  Blink
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  This example code is in the public domain.
 */
 
// Pin 13 has an LED connected on most Arduino boards.
// give it a name:
int glass_red = 8;
int glass_blue = 9;
int glass_green = 10;

int switch_red = 0;
int switch_blue = 1;
int switch_green = 2;
char match[3];
int val_switch_red = 0;
int val_switch_blue = 0;
int val_switch_green = 0;

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(glass_red, OUTPUT);
  pinMode(glass_blue, OUTPUT);
  pinMode(glass_green, OUTPUT); 
  
  pinMode(switch_red, INPUT);
  pinMode(switch_blue, INPUT);
  pinMode(switch_green, INPUT);
  Serial.begin(9600);
  
  Serial.println("Assign matching eg: mrg, mbr,..");
}

// the loop routine runs over and over again forever:
void loop() {
  digitalWrite(glass_red, HIGH);   
  digitalWrite(glass_blue, HIGH);  
  digitalWrite(glass_green, HIGH); 
  

 
  
  
  memset(match, 0, 2);
  
  readSerialString(match);
  
  
  
  while (match[0] == 'm'){
    
//    Serial.println(match);    
    
    val_switch_red = analogRead(switch_red);   
    val_switch_blue = analogRead(switch_blue);  
    val_switch_green = analogRead(switch_green);
    
    if (val_switch_red > 0){
       Serial.println("ir");      
    }
    
    if (val_switch_blue > 0){
       Serial.println("ib");      
    }
    
    if (val_switch_green > 0){
       Serial.println("ig");      
    }
    
//    Serial.println("match");

    for (int i=1; i<=2; i++){
       if (match[i] == 'r'){
        
         digitalWrite(glass_red, LOW);
         delay(100);
         digitalWrite(glass_red, HIGH); 
       } 
       if (match[i] == 'g'){
         digitalWrite(glass_green, LOW);
          delay(100);
         digitalWrite(glass_green, HIGH);  
       } 
       if (match[i] == 'b'){
         digitalWrite(glass_blue, LOW);
         delay(100);
         digitalWrite(glass_blue, HIGH);  
       } 
    }
    
    analogWrite(switch_red, 0);   
    analogWrite(switch_blue, 0);  
    analogWrite(switch_green, 0);
    
    
    
    readSerialString(match);
    
    if (match[0] == 'x'){
       //exit out of the while loop
       break;
    }
    
   
    
  }
  
  
  delay(100);

}

//read a string from the serial and store it in an array
//you must supply the array variable
void readSerialString (char *strArray) {
  int i = 0;
  
  
  if(!Serial.available()) {
    //Laura: If there is nothing in the serial port (enter has not been hit) then send nothing back
    return;
  }
  
  //Laura: If there is something in the serial port... 
  while (Serial.available()) {
    //..read each character into the array, one at a time
    strArray[i] = Serial.read();
    i++;
  }
}
