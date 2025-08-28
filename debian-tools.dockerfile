# provides a build environent for Debian Linux and WASM
FROM docker.io/debian:stable

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin:/usr/local/bin/" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++ ANDROID_HOME=/usr/lib/android-sdk SOURCE_DATE_EPOCH=0

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
RUN cargo install wasm-pack wasm-bindgen-cli

WORKDIR /

# configure the image
RUN yes | sdkmanager --licenses && \
    mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
    git config --global --add safe.directory /workspace
