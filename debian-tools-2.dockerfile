FROM docker.io/debian:13

RUN apt update && apt upgrade -y && apt install -y --no-install-recommends curl nix nano wget gpg zsh git pkg-config zip unzip tar postgresql postgresql-client \
    build-essential make cmake ninja-build libgnustep-base-dev clang clang-format clang-tidy clangd clang-tools lldb \
    bacon cargo rustc rustfmt rust-doc \
    swiftlang swiftlang-dev swiftlang-doc \
    npm \
    gradle android-sdk default-jdk
