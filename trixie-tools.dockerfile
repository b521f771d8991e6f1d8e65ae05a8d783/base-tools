ARG DEBIAN_VERSION=trixie
ARG SWIFT_VERSION=6.0.3
ARG SWIFT_CHECKSUM=67f765e0030e661a7450f7e4877cfe008db4f57f177d5a08a6e26fd661cdd0bd
ARG STATIC_SDK_VERSION=0.0.1

FROM docker.io/debian:${DEBIAN_VERSION}

ARG SWIFT_VERSION
ARG SWIFT_CHECKSUM
ARG STATIC_SDK_VERSION

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++ ANDROID_HOME=/usr/lib/android-sdk

RUN apt update && apt upgrade -y && apt install -y nix nano curl wget gpg rpm zsh zip git  \
    make cmake ninja-build \
    build-essential musl-tools gdb gcc g++ gobjc gobjc++ gnustep-devel clang clang-format clang-tidy clangd clang-tools gdb lldb \
    swiftlang swiftlang-dev swiftlang-doc swift-doc \
    rustup \
    npm \
    android-sdk sdkmanager default-jdk

RUN swift sdk install https://download.swift.org/swift-${SWIFT_VERSION}-release/static-sdk/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz --checksum ${SWIFT_CHECKSUM}; exit 0

# configure the image
RUN yes | sdkmanager --licenses && \
    mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
    git config --global --add safe.directory /workspace

# set up rust and dependencies not available via apt
RUN rustup default stable
RUN rustup target install x86_64-unknown-linux-musl wasm32-unknown-unknown aarch64-unknown-linux-musl
RUN cargo install bacon wasm-pack wasm-bindgen-cli
