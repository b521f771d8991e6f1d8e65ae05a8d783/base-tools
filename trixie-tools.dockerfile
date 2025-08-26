# provides a build environent for Debian Linux, Static Linux, Windows and WASM (we use Linux do build Windows binaries so that we can stay on free software)
FROM docker.io/debian:trixie

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++ ANDROID_HOME=/usr/lib/android-sdk

RUN apt update && apt upgrade -y && apt install -y nix nano curl wget gpg rpm zsh zip git jq pkg-config \
    make cmake ninja-build \
    build-essential musl-tools gdb gcc g++ gobjc gobjc++ gnustep-devel gdb \
    clang clang-format clang-tidy clangd clang-tools lldb \
    swiftlang swiftlang-dev swiftlang-doc \
    emscripten emscripten-doc wasmedge \
    rustup bacon \
    npm \
    android-sdk sdkmanager default-jdk maven gradle \
    lighttpd

# set up rust
RUN rustup default stable
RUN rustup target install x86_64-unknown-linux-musl aarch64-unknown-linux-musl x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu wasm32-unknown-unknown

# dependencies not available via apt
RUN npm install -g wasm-pack

WORKDIR /

# configure the image
RUN yes | sdkmanager --licenses && \
    mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
    git config --global --add safe.directory /workspace
