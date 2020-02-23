shrpx
================

### spdy2http
```bash
$ docker run -it --restart always -p 8000:8000/tcp --log-opt max-size=1m --log-opt max-file=1 -e "SPDY-PROXY-ADDR=host" --name shrpx land007/shrpx:latest
```
