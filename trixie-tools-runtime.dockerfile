ARG DEBIAN_VERSION=trixie

FROM docker.io/debian:${DEBIAN_VERSION}-slim

RUN apt update && apt upgrade -y && apt install -y libswiftlang gnustep-gui-runtime
