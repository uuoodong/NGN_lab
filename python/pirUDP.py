import RPi.GPIO as GPIO
import time
import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

GPIO.setmode(GPIO.BCM)
pir_pin = 18
GPIO.setup(pir_pin, GPIO.IN)
led_pin1 = 23
GPIO.setup(led_pin1, GPIO.OUT)

def loop():
    cnt = 0
    while True:
        if GPIO.input(pir_pin) == True:
            cnt += 1
            print("counting number%d" % cnt)
            GPIO.output(led_pin1, True)
            sock.sendto(str(GPIO.input(pir_pin)).encode(), ('127.0.0.1',9999))
            time.sleep(1)
        else:
            GPIO.output(led_pin1, False)
            time.sleep(1)

try :
    loop()

except KeyboardInterrupt:
    pass

finally:
    GPIO.cleanup()



