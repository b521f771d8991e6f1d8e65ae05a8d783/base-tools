FROM docker.io/debian:latest

RUN apt update && apt upgrade -y && apt install -y --no-install-recommends curl nix nano wget gpg ssh zsh git gh sudo git-lfs pkg-config zip unzip tar postgresql postgresql-client \
    build-essential make cmake ninja-build libgnustep-base-dev clang clang-format clang-tidy clangd clang-tools lldb \
    bacon cargo rustc rustfmt rust-doc \
    swiftlang swiftlang-dev swiftlang-doc \
    npm

RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid 1000 -m -s /bin/bash vscode \
    && echo "vscode ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode

RUN mkdir -p ~/.config/nix && \
  echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
  git config --global --add safe.directory /workspace

VOLUME /nix
