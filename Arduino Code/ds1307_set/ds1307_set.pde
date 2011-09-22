/*Set the current time in a DS1307 Real Time Clock (RTC)
 *Written by Riccardo Attilio Galli at http://www.sideralis.org
 *
 *Released under the GPL License
 *http://www.gnu.org/licenses/gpl-3.0-standalone.html
 *
 *DS1307 library required, from the arduino Playground
 *
 *Python module for sending the current time via serial:
 *
 *import serial
 *import os,sys,time
 *ser=serial.Serial("/dev/ttyUSB1",9600,timeout=1)
 *ser.write(time.strftime('%Y-%m-%d-%H-%M-%S-%w-',time.localtime()))
 *ser.close()
 */

#include <WProgram.h>
#include <Wire.h>
#include <DS1307.h> // written by  mattt on the Arduino forum and modified by D. Sjunnesson


void setup() {
  Serial.begin(9600);
}

int *readTimeFromSerial(){
  /* example: 2011-02-20-18-04-14-0- */
  char buff[5],curChar,separator='-';
  int *timeData=NULL, numToken=7, timeTokenIndex=0,strtime_length=22;
  
  if (Serial.available()>=strtime_length) {
    timeData=(int*)malloc(numToken*sizeof(int));
    int i=strtime_length,k=0;
    while(i--) {
      curChar=Serial.read();
      if (curChar==separator) {
        buff[k]=' ';
        timeData[timeTokenIndex++]=atoi(buff);
        k=0;
      } else buff[k++]=curChar;
    }
  }
  
  return timeData;
}

void loop() {

  int *foo=readTimeFromSerial();
  if (foo!=NULL) {
    
    for (int i=0;i<7;i++){
    Serial.println(foo[i]);
    }
    
    //RTC.stop();
    RTC.set(DS1307_YR,foo[0]-2000);       //set the year
    RTC.set(DS1307_MTH,foo[1]);      //set the month
    RTC.set(DS1307_DATE,foo[2]);     //set the date
    RTC.set(DS1307_HR,foo[3]);      //set the hours
    RTC.set(DS1307_MIN,foo[4]);     //set the minutes
    RTC.set(DS1307_SEC,foo[5]);      //set the seconds
    RTC.set(DS1307_DOW,foo[6]);      //set the day of the week
    RTC.start();
  }
  
  /* Print data read from the DS1307 in a fancy way */
  Serial.print(RTC.get(DS1307_HR,true)); //read the hour and also update all the values by pushing in true
  Serial.print(":");
  Serial.print(RTC.get(DS1307_MIN,false));//read minutes without update (false)
  Serial.print(":");
  Serial.print(RTC.get(DS1307_SEC,false));//read seconds
  Serial.print("      ");                 // some space for a more happy life
  Serial.print(RTC.get(DS1307_DATE,false));//read date
  Serial.print("/");
  Serial.print(RTC.get(DS1307_MTH,false));//read month
  Serial.print("/");
  Serial.print(RTC.get(DS1307_YR,false)); //read year 
  Serial.println();
  
  delay(1000);

}


