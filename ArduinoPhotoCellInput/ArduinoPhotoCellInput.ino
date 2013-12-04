/*
 * Resistive Sensor Input
 * Takes the input from a resistive sensor, e.g., FSR or photocell
 * Dims the LED accordingly, and sends the value (0-255) to the serial port
 */
int sensorPin0 = 0;  // select the input pin for the sensor
int sensorPin1 = 1;
int sensorPin2 = 2;
int sensorPin3 = 3;
int sensorPin4 = 4;
int ledPin = 7;    // select the output pin for the LED
int value[4] ;

void setup() {
  Serial.flush();
  Serial.begin(9600);
}
void loop() {
  Serial.flush();
  value[0] = analogRead(sensorPin0); // read the value from the sensor, 0-1023
  value[1] = analogRead(sensorPin1); // read the value from the sensor, 0-1023
  value[2] = analogRead(sensorPin2);
  value[3] = analogRead(sensorPin3);
  value[4] = analogRead(sensorPin4);
  int minval = 1000;
  int maxval = -1000;
  int maxpin = -1;
  int minpin = -1;
  for (int i =0; i<5 ;i++)
  {
    if (value[i] < minval)
    {
      minval = value[i];
      minpin = i;
    }
    if (value[i] > maxval)
    {
      maxval = value[i];
      maxpin = i;
      
    }
    
  }  
  
  if (maxpin==0)
  {
    Serial.println(100);
    //Serial.println(maxpin);
  }
  else
  {
    Serial.println(minpin);
  }
  
  
 //Serial.println(minpin);
 digitalWrite(ledPin, HIGH); 
 Serial.flush();

 
}

