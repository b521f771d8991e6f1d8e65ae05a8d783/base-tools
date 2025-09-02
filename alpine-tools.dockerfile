# Provides a build environment for Static Linux environments - less features that Debian (no swift support, no GNUStep-Support, no support for cross-compiling to -gnu instead of musl)
FROM docker.io/rust:alpine

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin:/usr/local/bin/" \
    CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++ ANDROID_HOME=/usr/lib/android-sdk SOURCE_DATE_EPOCH=0

# Install necessary packages
RUN apk update && apk upgrade && apk add nix nano curl wget gnupg rpm zsh zip git jq pkgconfig \
    make cmake ninja \
    build-base alpine-sdk musl-dev gdb gcc g++ gcc-objc \
    clang clang-dev lldb \
    emsdk \
    npm \
    android-tools openjdk11 maven gradle \
    lighttpd

# Set up Rust
RUN rustup default stable
RUN rustup target install wasm32-unknown-unknown

# Install dependencies not available via apk
RUN npm install -g wasm-pack
RUN cargo install bacon wasm-bindgen-cli

WORKDIR /

# Configure the image
RUN mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
    git config --global --add safe.directory /workspace

