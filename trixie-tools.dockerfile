# provides a build environent for Debian Linux, Static Linux and WASM
ARG DEBIAN_VERSION=trixie

FROM docker.io/debian:${DEBIAN_VERSION}

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++ ANDROID_HOME=/usr/lib/android-sdk

RUN apt update && apt upgrade -y && apt install -y nix nano curl wget gpg rpm zsh zip git jq pkg-config \
    make cmake ninja-build \
    build-essential musl-tools gdb gcc g++ gobjc gobjc++ gnustep-devel gdb \
    clang clang-format clang-tidy clangd clang-tools lldb \
    swiftlang swiftlang-dev swiftlang-doc \
    emscripten emscripten-doc wasmedge \
    rustup \
    npm \
    android-sdk sdkmanager default-jdk maven gradle \
    lighttpd

# set up rust and dependencies not available via apt
RUN rustup default stable
RUN rustup target install x86_64-unknown-linux-musl aarch64-unknown-linux-musl x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu wasm32-unknown-unknown
RUN cargo install cargo-binstall
RUN cargo binstall bacon wasm-pack wasm-bindgen-cli

WORKDIR /tmp
RUN SWIFT_VERSION=$(swift --version | grep -oP '\d+\.\d+\.\d+' | head -n 1) && wget -O static-sdk.artifactbundle.tar.gz https://download.swift.org/swift-${SWIFT_VERSION}-release/static-sdk/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz
RUN swift sdk install ./static-sdk.artifactbundle.tar.gz --checksum $(swift package compute-checksum ./static-sdk.artifactbundle.tar.gz) 
RUN rm ./static-sdk.artifactbundle.tar.gz

WORKDIR /

# configure the image
RUN yes | sdkmanager --licenses && \
    mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
    git config --global --add safe.directory /workspace
