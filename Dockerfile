FROM debian:stable

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev curl lbzip2 make g++

RUN curl -L -O http://jiayq-singapore.s3.amazonaws.com/spdylay-1.4.0.tar.bz2 \
    && tar xf spdylay-1.4.0.tar.bz2 \
    && cd spdylay-1.4.0 \
    && autoreconf -i \
    && automake \
    && autoconf \
    && ./configure \
    && make

#CMD ["./spdylay-1.4.0/src/shrpx", "--accesslog", "-b", "web,80", "/ssl/server.key", "/ssl/server.crt"]
ENV SPDY_PROXY_ADDR="host" \
	SPDY_PROXY_PORT="443"
EXPOSE 8000/tcp

CMD /spdylay-1.4.0/src/shrpx -k -p --accesslog -f 0.0.0.0,8000 -b ${SPDY_PROXY_ADDR},${SPDY_PROXY_PORT}
#docker run -it --restart always -p 8000:8000/tcp --log-opt max-size=1m --log-opt max-file=1 -e "SPDY_PROXY_ADDR=host1" --name shrpx land007/shrpx:latest
#> docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t land007/shrpx --push .
