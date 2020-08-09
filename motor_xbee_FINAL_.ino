
#include <Arduino.h>


#define InL1            13                      // motor pin
#define PWML            10                      // PWM motor pin  
#define InL2            9                       // motor pin  

#define InR1            7                       // motor pin
#define PWMR            6                       // PWM motor pin
#define InR2            4                       // motor pin 



 
void motor_init(){
    
     pinMode(51,OUTPUT);
    pinMode(InL1, OUTPUT);
    pinMode(InL2, OUTPUT);
    pinMode(PWML, OUTPUT);
    
    pinMode(InR1, OUTPUT);
    pinMode(InR2, OUTPUT);
    pinMode(PWMR, OUTPUT);
}
void motorForwardL(int PWM_val)  {
    analogWrite(PWML, PWM_val);
     analogWrite(PWMR, PWM_val);
    digitalWrite(InL1, LOW);
    digitalWrite(InL2, HIGH);
        digitalWrite(InR1,HIGH);
    digitalWrite(InR2, LOW);
}

void motorForwardR(int PWM_val)  {
    analogWrite(PWMR, PWM_val);
    analogWrite(PWML, PWM_val);
       digitalWrite(InL1, HIGH);
    digitalWrite(InL2, LOW);
    digitalWrite(InR1, LOW);
    digitalWrite(InR2, HIGH);
}

void motorForward(int PWM_val)  {
    analogWrite(PWML, PWM_val);
    analogWrite(PWMR, PWM_val);
    digitalWrite(InL1, LOW);
    digitalWrite(InL2, HIGH);
    digitalWrite(InR1, LOW);
    digitalWrite(InR2, HIGH);
}

void motorBackward(int PWM_val)  {
    analogWrite(PWML, PWM_val);
    analogWrite(PWMR, PWM_val);
    digitalWrite(InL1, HIGH);
    digitalWrite(InL2, LOW);
     digitalWrite(InR1, HIGH);
    digitalWrite(InR2, LOW);
   
}

void motorStop(){
      analogWrite(PWML, 0);
    analogWrite(PWMR, 0);
    digitalWrite(InL1, LOW);
    digitalWrite(InL2, LOW);
     digitalWrite(InR1,LOW);
    digitalWrite(InR2, LOW);
  }

void setup() {

  //Start the serial communication
  Serial.begin(9600);
  Serial1.begin(9600);//Baud rate must be the same as is on xBee module
  
  motor_init();
  
}
void loop(){
    if(Serial1.available()>=21){
    if(Serial1.read()==0X7E){
      //Serial.print("123");
      for(int i=1;i<=10;i++){
      byte discardByte=Serial1.read();
    }


  Serial.println("es");
    byte es_LSB=Serial1.read();
    Serial.print(es_LSB,HEX);
    byte es_MSB=Serial1.read();
    Serial.print("  ");
    Serial.print(es_MSB,HEX);
    Serial.println();
    int es_Reading=es_MSB+(es_LSB*256);
    Serial.print(es_Reading);
    Serial.println();

    
//    Serial.println("ad0");
    byte ad0_LSB=Serial1.read();
//    Serial.print(ad0_LSB,HEX);
    byte ad0_MSB=Serial1.read();
//    Serial.print("  ");
//    Serial.print(ad0_MSB,HEX);
//    Serial.println();
    int ad0_Reading=ad0_MSB+(ad0_LSB*256);
    Serial.print(ad0_Reading);
    Serial.println();
//    
//    Serial.println("ad1");
    byte ad1_LSB=Serial1.read();
//    Serial.print(ad1_LSB,HEX);
    byte ad1_MSB=Serial1.read();
//    Serial.print("  ");
//    Serial.print(ad1_MSB,HEX);
//    Serial.println();
    int ad1_Reading=ad1_MSB+(ad1_LSB*256);
    Serial.print(ad1_Reading);
    Serial.println();
     
//    Serial.println("ad2");
    byte ad2_LSB=Serial1.read();
//    Serial.print(ad2_LSB,HEX);
    byte ad2_MSB=Serial1.read();
//    Serial.print("  ");
//    Serial.print(ad2_MSB,HEX);
//    Serial.println();
    int ad2_Reading=ad2_MSB+(ad2_LSB*256);
    Serial.print(ad2_Reading);
    Serial.println();
//     
//    Serial.println("ad3");
    byte ad3_LSB=Serial1.read();
//    Serial.print(ad3_LSB,HEX);
    byte ad3_MSB=Serial1.read();
//    Serial.print("  ");
//    Serial.print(ad3_MSB,HEX);
//    Serial.println();
    int ad3_Reading=ad3_MSB+(ad3_LSB*256);
    Serial.print(ad3_Reading);
    Serial.println();
    
    if(ad0_Reading==1023 && ad1_Reading==1023 && ad2_Reading==1023 && ad3_Reading==1023)
    {
      Serial.println("stop");
      motorStop();
    }
    else if(ad0_Reading==0 && ad1_Reading==1023 && ad2_Reading==1023 && ad3_Reading==1023)
    {
      Serial.println("forward position for joystick of yellow-orange wire");
      motorForward(180);
    }
    else if(ad0_Reading==1023 && ad1_Reading==0 && ad2_Reading==1023 && ad3_Reading==1023)
    {
      Serial.println("right position for joystick of yellow-orange wire");
      motorForwardR(180);
    }
    else if(ad0_Reading==1023 && ad1_Reading==1023 && ad2_Reading==0 && ad3_Reading==1023)
    {
      Serial.println("forward position for joystick of red-blue wire");
      motorBackward(180);
    }
    else if(ad0_Reading==1023 && ad1_Reading==1023 && ad2_Reading==1023 && ad3_Reading==0)
    {
      Serial.println("right position for joystick of red-blue wire");
      motorForwardL(180);
    }
     if(es_Reading==0)
    {
      Serial.println("high");
      digitalWrite(51,HIGH);
    }
    else if(es_Reading==16)
    {
      Serial.println("low");
      digitalWrite(51,LOW);
    }

  //delay(5000);     
     
    }
   
  }
}
