ARG DEBIAN_VERSION=trixie
ARG SWIFT_VERSION=6.1.2
ARG SWIFT_STATIC_SDK_CHECKSUM=df0b40b9b582598e7e3d70c82ab503fd6fbfdff71fd17e7f1ab37115a0665b3b
ARG SWIFT_STATIC_SDK_VERSION=0.0.1
ARG SWIFT_WASM_SDK_CHECKSUM=2ff6242bb1396ed19f935ea5a3e169543baf401f9a6a6386cf59dab6fdf0d814

FROM docker.io/debian:${DEBIAN_VERSION}

ARG SWIFT_VERSION
ARG SWIFT_STATIC_SDK_CHECKSUM
ARG SWIFT_STATIC_SDK_VERSION
ARG SWIFT_WASM_SDK_CHECKSUM

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin:/root/.local/share/swiftly/bin/" CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++ ANDROID_HOME=/usr/lib/android-sdk

RUN apt update && apt upgrade -y && apt install -y nix nano curl wget gpg rpm zsh zip git jq \
    libicu-dev libcurl4-openssl-dev libedit-dev libsqlite3-dev libpython3-dev pkg-config libstdc++-12-dev \
    make cmake ninja-build \
    build-essential musl-tools gdb gcc g++ gobjc gobjc++ gnustep-devel gdb \
    clang clang-format clang-tidy clangd clang-tools lldb \
    emscripten emscripten-doc wasmedge \
    rustup \
    npm \
    android-sdk sdkmanager default-jdk maven gradle \
    nginx

RUN curl -O https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz && \
    tar zxf swiftly-$(uname -m).tar.gz && \
    ./swiftly init --quiet-shell-followup -y --platform debian12 && \
    . "${SWIFTLY_HOME_DIR:-$HOME/.local/share/swiftly}/env.sh" && \
    hash -r
RUN swiftly install ${SWIFT_VERSION}
RUN swift sdk install https://download.swift.org/swift-${SWIFT_VERSION}-release/static-sdk/swift-${SWIFT_VERSION}-RELEASE/swift-${SWIFT_VERSION}-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz --checksum ${SWIFT_STATIC_SDK_CHECKSUM}
#RUN swift sdk install https://download.swift.org/swift-6.2-branch/wasm-sdk/swift-6.2-DEVELOPMENT-SNAPSHOT-2025-07-26-a/swift-6.2-DEVELOPMENT-SNAPSHOT-2025-07-26-a_wasm.artifactbundle.tar.gz --checksum ${SWIFT_WASM_SDK_CHECKSUM}

# configure the image
RUN yes | sdkmanager --licenses && \
    mkdir -p ~/.config/nix && \
    echo 'extra-experimental-features = flakes nix-command' > ~/.config/nix/nix.conf && \
    git config --global --add safe.directory /workspace

# set up rust and dependencies not available via apt
RUN rustup default stable
RUN rustup target install x86_64-unknown-linux-musl aarch64-unknown-linux-musl x86_64-unknown-linux-gnu aarch64-unknown-linux-gnu wasm32-unknown-unknown
RUN cargo install cargo-binstall
RUN cargo binstall bacon wasm-pack wasm-bindgen-cli
