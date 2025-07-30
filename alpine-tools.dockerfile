FROM docker.io/alpine:latest

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin:/root/.rustup/toolchains/stable-x86_64-unknown-linux-musl/bin/" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++ ANDROID_HOME=/usr/lib/android-sdk
RUN apk update && apk upgrade && apk add nix nano curl wget gpg rpm zsh zip git jq \
    make cmake ninja-build \
    alpine-sdk musl-dev gdb gcc g++ gdb \
    clang clang-extra-tools  lldb \
    rustup \
    npm \
    maven gradle \
    lighttpd
# currently not available in alpine: swiftlang swiftlang-dev swiftlang-doc android-sdk default-jdk gobjc gobjc++ gnustep-devel sdkmanager emscripten emscripten-doc wasmedge
# musl-tools -> musl-dev
# build-essential -> alpine-sdk
# clang-format clang-tidy clangd clang-tools -> clang-extra-tools

# set up rust and dependencies not available via apt
RUN echo 1 | rustup-init
RUN cargo install cargo-binstall
RUN cargo binstall bacon wasm-pack wasm-bindgen-cli

# configure the image
RUN mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
    git config --global --add safe.directory /workspace