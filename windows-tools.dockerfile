FROM docker.io/alpine:latest

RUN apk update && apk upgrade && apk add wine

SHELL ["/usr/bin/wine", "cmd"]
CMD ["/usr/bin/wine", "cmd"]
