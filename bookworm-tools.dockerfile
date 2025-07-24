ARG DEBIAN_VERSION=bookworm
ARG SWIFT_VERSION=6.1.2
ARG SWIFT_CHECKSUM=df0b40b9b582598e7e3d70c82ab503fd6fbfdff71fd17e7f1ab37115a0665b3b
ARG STATIC_SDK_VERSION=0.0.1

FROM docker.io/swift:${SWIFT_VERSION}-${DEBIAN_VERSION}

ARG SWIFT_VERSION
ARG SWIFT_CHECKSUM
ARG STATIC_SDK_VERSION

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++ ANDROID_HOME=/usr/lib/android-sdk

RUN swift sdk install https://download.swift.org/swift-${SWIFT_VERSION}-release/static-sdk/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE_static-linux-${STATIC_SDK_VERSION}.artifactbundle.tar.gz --checksum ${SWIFT_CHECKSUM}

RUN apt update && apt upgrade -y && apt install -y nix nano curl wget gpg rpm zsh zip git  \
    make cmake ninja-build \
    build-essential gdb musl-tools clang clang-format clang-tidy clangd clang-tools gdb lldb \
    emscripten emscripten-doc \
    npm \
    android-sdk sdkmanager default-jdk

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN rustup default stable
RUN rustup target install x86_64-unknown-linux-musl wasm32-unknown-unknown aarch64-unknown-linux-musl
RUN cargo install cargo-binstall
RUN cargo binstall bacon wasm-pack wasm-bindgen-cli

# configure the image
RUN yes | sdkmanager --licenses && \
    mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
    git config --global --add safe.directory /workspace
