FROM resin/rpi-raspbian:stretch

# Var
ARG VERSION_NGINX=1.13.6
ARG CONFPATH=/usr/local/nginx/conf

# Base
RUN apt-get update && apt-get install sudo && sudo apt-get -y install nano wget unzip zlib1g-dev build-essential libpcre3 libpcre3-dev libssl-dev
# RUN sudo apt-get -y remove nginx

# Nginx
RUN wget "http://nginx.org/download/nginx-$VERSION_NGINX.tar.gz"

# Rtmp Module
RUN wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
RUN tar -zxvf nginx-$VERSION_NGINX.tar.gz
RUN unzip master.zip

# Build
RUN cd nginx-$VERSION_NGINX && ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master && make && sudo make install

# conf
ADD conf/nginxRTMP.conf $CONFPATH/nginxRTMP.conf
RUN cat $CONFPATH/nginxRTMP.conf >> $CONFPATH/nginx.conf

# FROM arm32v6/alpine:3.6

EXPOSE 80 1935
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]