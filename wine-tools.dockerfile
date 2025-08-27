FROM docker.com/debian:trixie

RUN dpkg --add-architecture i386 && apt update && apt upgrade -y && apt install -y wine
