import sys
import numpy as np
import cv2
import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host = '192.168.12.97'

center = 0

port = 2222

client.connect((host,port))

sys.path.append('/usr/local/lib/python2.7/site-packages')

vid_capture = cv2.VideoCapture(0, cv2.CAP_DSHOW)
vid_capture.set(cv2.CAP_PROP_FRAME_WIDTH, 2048)
vid_capture.set(cv2.CAP_PROP_FRAME_HEIGHT, 1080)

while (True):
    ret, frame = vid_capture.read()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    cimg = frame.copy()
    rows = gray.shape[0]
    circles = cv2.HoughCircles(gray, cv2.HOUGH_GRADIENT, 1, rows / 8,
                               param1=100, param2=50,
                               minRadius=60, maxRadius=150)
    
    if circles is not None:
        circles = np.uint16(np.around(circles))
        for i in circles[0, :]:
            center = (i[0], i[1] )
            cv2.circle(gray, center, 1, (0, 100, 100), 3)
            radius = i[2]
            cv2.circle(gray, center, radius, (0, 255, 0), 3)
    
    client.send(bytes(str(center) + "A", 'utf-8'))
    data = client.recv(1024)
    cv2.imshow('video',gray)

    client.close()
    break
    
    

vid_capture.release()
cv2.destroyAllWindows()