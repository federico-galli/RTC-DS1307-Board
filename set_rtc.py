#!/usr/bin/env python

import serial
import os,sys,time
ser=serial.Serial("/dev/ttyUSB0",9600,timeout=1)
ser.write(time.strftime('%Y-%m-%d-%H-%M-%S-%w-',time.localtime()))
ser.close()
