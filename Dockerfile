FROM resin/rpi-raspbian:stretch

# Var
ARG VERSION_NGINX=1.13.6
ARG CONFPATH=/usr/local/nginx/conf

# Base
RUN apt-get update && \
    apt-get -y install nano \
        wget \
        git \
        unzip \
        curl \
        zlib1g-dev \
        build-essential \
        libpcre3 \
        libpcre3-dev \
        libssl-dev \
        libomxil-bellagio-dev \
        libpcre++-dev \
        libcurl4-openssl-dev

# Libs
COPY conf/opt/vc/lib/* /opt/vc/lib/

# Uninstall ffmpeg and compile ffmpeg to use the GPU (with the OpenMAX driver)
RUN apt-get -y autoremove ffmpeg
RUN git clone https://github.com/FFmpeg/FFmpeg.git && \
    cd FFmpeg && \
    git checkout release/3.4 && \
    ./configure --arch=armel --target-os=linux --enable-gpl --enable-libx264 --enable-omx --enable-omx-rpi --enable-nonfree
RUN cd FFmpeg && \
    make -j4 && \
    make install

# Nginx
RUN wget "http://nginx.org/download/nginx-$VERSION_NGINX.tar.gz"

# Rtmp Module
RUN wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
RUN tar -zxvf nginx-$VERSION_NGINX.tar.gz
RUN unzip master.zip

# Build Nginx with Rtmp module
RUN cd nginx-$VERSION_NGINX && \
    ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master && \
    make && \
    make install

# Conf
ADD conf/nginxRTMP.conf $CONFPATH/nginxRTMP.conf
RUN cat $CONFPATH/nginxRTMP.conf >> $CONFPATH/nginx.conf

# FROM resin/rpi-raspbian:stretch
# FROM arm32v6/alpine:3.6

EXPOSE 80 1935 3000
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]