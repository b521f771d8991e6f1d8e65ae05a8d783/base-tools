ARG TOOLS_LIGHT_STATIC_BASE=tools-light
ARG TOOLS_BASE=tools-light
ARG TOOLS_STATIC_BASE=tools

ARG DEBIAN_VERSION=bookworm
ARG SWIFT_VERSION=6.1.2
ARG SWIFT_CHECKSUM=df0b40b9b582598e7e3d70c82ab503fd6fbfdff71fd17e7f1ab37115a0665b3b
ARG STATIC_SDK_VERSION=0.0.1

FROM docker.io/swift:${SWIFT_VERSION}-${DEBIAN_VERSION} AS tools-light

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++ ANDROID_HOME=/usr/lib/android-sdk

RUN apt update && apt upgrade -y && apt install -y nix nano curl wget gpg rpm zsh zip git  \
    make cmake ninja-build \
    build-essential gdb  \
    cargo rustc rust-all \
    npm \
    android-sdk sdkmanager default-jdk

# configure the image
RUN yes | sdkmanager --licenses && \
    mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
    git config --global --add safe.directory /workspace

FROM ${TOOLS_LIGHT_STATIC_BASE} AS tools-light-static

RUN apt install -y musl-tools

FROM ${TOOLS_BASE} AS tools

RUN apt install -y \
    clang clang-format clang-tidy clangd clang-tools gdb lldb
    # swift is already installed through our base image

FROM ${TOOLS_STATIC_BASE} AS tools-static

ARG SWIFT_CHECKSUM
ARG SWIFT_VERSION
ARG STATIC_SDK_VERSION

RUN apt install -y musl-tools
RUN swift sdk install https://download.swift.org/swift-${SWIFT_VERSION}-release/static-sdk/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE_static-linux-${STATIC_SDK_VERSION}.artifactbundle.tar.gz --checksum ${SWIFT_CHECKSUM}
