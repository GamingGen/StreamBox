# StreamBox

This project allows you to connect a WebCam to an RPI and use it as an RTMP server

_WIP_

#### GetStarted

Run this command to build :

`sudo docker build -t darkterra/streambox .`

Run this command to spawn conainer :

`sudo docker run --name StreamBOX1 --device /dev/video0:/dev/video0 -p 81:80 -p 1935:1935 -d darkterra/streambox`

Run this command if you need to go inside the container :

`sudo docker exec -it StreamBOX1 /bin/bash`

Run this command to start Record :

`ffmpeg -f video4linux2 -i /dev/video0 -an -f flv rtmp://localhost/live`