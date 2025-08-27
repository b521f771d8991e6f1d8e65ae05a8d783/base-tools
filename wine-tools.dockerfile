FROM docker.io/debian:trixie

RUN apt update && apt upgrade -y && apt install -y wine

SHELL ["/usr/bin/wine", "cmd"]
