ARG DEBIAN_VERSION=trixie

FROM docker.io/debian:${DEBIAN_VERSION}-slim

RUN apt update && apt upgrade -y && apt install -y libswiftlang gnustep-gui-runtime

RUN mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf
