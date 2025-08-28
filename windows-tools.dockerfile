FROM docker.io/debian:latest

RUN apt update && apt upgrade -y && apt install -y wine

SHELL ["/usr/bin/wine", "cmd"]
CMD ["/usr/bin/wine", "cmd"]
