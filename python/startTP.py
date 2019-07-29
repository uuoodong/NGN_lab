import socket
import time

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

start = 1
time.sleep(10)
sock.sendto(str(start).encode(), ('127.0.0.1' , 10002))
