FROM docker.io/swift:bookworm

RUN apt update && apt upgrade -y && apt install -y nix

RUN mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf
