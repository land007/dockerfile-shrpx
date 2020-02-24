shrpx
================

### spdy2http
```bash
$ docker run -it --restart always -p 8000:8000/tcp --log-opt max-size=1m --log-opt max-file=1 -e "SPDY_PROXY_ADDR=host1" --name shrpx land007/shrpx:latest
```
