FROM arm32v6/alpine:3.6

ARG VERSION_NGINX=1.13.5

RUN sudo apt-get install build-essential libpcre3 libpcre3-dev libssl-dev
RUN wget http://nginx.org/download/nginx-$VERSION_NGINX.tar.gz
RUN wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
RUN tar -zxvf nginx-$VERSION_NGINX.tar.gz
RUN unzip master.zip
RUN cd nginx-$VERSION_NGINX
RUN ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master
RUN make
RUN sudo make install