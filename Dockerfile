FROM debian:stable

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev curl lbzip2 make g++

RUN curl -L -O https://github.com/tatsuhiro-t/spdylay/releases/download/v1.3.2/spdylay-1.3.2.tar.bz2 \
    && tar xf spdylay-1.3.2.tar.bz2 \
    && cd spdylay-1.3.2 \
    && autoreconf -i \
    && automake \
    && autoconf \
    && ./configure \
    && make

#CMD ["./spdylay-1.3.2/src/shrpx", "--accesslog", "-b", "web,80", "/ssl/server.key", "/ssl/server.crt"]
ENV SPDY-PROXY-ADDR="" \
ENV SPDY-PROXY-PORT="443"
EXPOSE 8000/tcp

CMD /spdylay-1.3.2/src/shrpx -k -p --accesslog -f 0.0.0.0,8000 -b ${SPDY-PROXY-ADDR},${SPDY-PROXY-PORT}
#docker run -it --restart always -p 8000:8000/tcp --log-opt max-size=1m --log-opt max-file=1 -e "SPDY-PROXY-ADDR=host" --name shrpx lancechen/shrpx:latest
