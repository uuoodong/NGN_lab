import time
import cv2

import socket
import os
import RPi.GPIO as GPIO
#recording
url = 'rtsp://CVCam.iptime.org:554/profile2/media.smp'
url2 = 'rtsp://admin:888888@CVCam.iptime.org:10554/tcp/av0_0'
capture = cv2.VideoCapture(url)
capture2 = cv2.VideoCapture(url2)
fourcc = cv2.VideoWriter_fourcc(*'H264')
record = False
#socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('127.0.0.1', 10001))
#LED
GPIO.setmode(GPIO.BCM)
GPIO.setup(7, GPIO.OUT)


def loop():
    while True:
        time.sleep(1)
        data, addr = sock.recvfrom(65535)
        value = data.decode()[0]
        ret, frame = capture.read()
        selectFlag = 0
        if(value == '1'):
            now = time.localtime()
            date = "%04d-%02d-%02d_%02d-%02d" %(now.tm_year, now.tm_mon, now.tm_mday, now.tm_hour, now.tm_min)
            print(date)
            #camera.start_recording('/home/pi/Raspberry_Pi/k.h264')
            #camera.start_recording('/usr/local/tomcat9/webapps/TheftPrevention/video/k.h264')
            record = True
            GPIO.output(7,True)
            video = cv2.VideoWriter("/home/pi/Raspberry_Pi/h.mp4", fourcc, 20.0, (640, frame.shape[0]))
            video2 = cv2.VideoWriter("/home/pi/Raspberry_Pi/h2.mp4", fourcc, 20.0, (1920, 1080))
            while(selectFlag!=1200):
                ret, frame = capture.read()
                ret2, frame2 = capture2.read()
                selectFlag+=1
                fram2 = cv2.resize(frame2,(640, 360), interpolation = cv2.INTER_AREA)
                video.write(frame)
                video2.write(frame2)
            video.release() #memory clear
            record = False
            #time.sleep(60)
            #camera.stop_recording()
            #os.system('MP4Box -add /home/pi/Raspberry_Pi/k.h264 /home/pi/Raspberry_Pi/h.mp4')
            os.system('sudo mv /home/pi/Raspberry_Pi/h.mp4 /usr/local/tomcat9/webapps/TheftPrevention/video/%s.mp4' %date)
            os.system('sudo mv /home/pi/Raspberry_Pi/h2.mp4 /usr/local/tomcat9/webapps/TheftPrevention/video/%s_2.mp4' %date)
            #os.system('sudo rm /home/pi/Raspberry_Pi/k.264')
            sock.sendto('7'.encode(),('127.0.0.1',10000))
            GPIO.output(7,False)
            time.sleep(1)
            value = '0'
            selectFlag=0
        #else
try:
    loop()

except KeyboardInterrupt:
    pass

finally:
    GPIO.cleanup()
    capture.release()
    cv2.destroyAllWindows()


    
