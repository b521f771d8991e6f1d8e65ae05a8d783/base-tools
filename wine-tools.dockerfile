FROM docker.io/debian:trixie

# cross-compiling to windows x64 (currently, mingw is not available on nix)
# this version has currently no support for swift, due to the lack of a FOSS runtime (just the msvc-abi)

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin:/usr/local/bin/" \
    CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ OBJC=x86_64-w64-mingw32-gcc OBJCXX=x86_64-w64-mingw32-g++ \
    SOURCE_DATE_EPOCH=0

RUN apt update && apt upgrade -y && apt-get install -y nix nano curl wget gpg rpm zsh zip git jq pkg-config \
    make cmake ninja-build \
    mingw-w64 gcc-mingw-w64 gobjc-mingw-w64 g++-mingw-w64 gobjc++-mingw-w64 \
    nsis lld llvm \
    rustup bacon \
    wine  \
    npm

RUN rustup default stable && rustup target add x86_64-pc-windows-gnu

ENV CMAKE_SYSTEM_NAME="Windows" \
    CMAKE_SYSTEM_PROCESSOR="x86_64" \
    CMAKE_RC_COMPILER="x86_64-w64-mingw32-windres" \
    CMAKE_FIND_ROOT_PATH="/usr/x86_64-w64-mingw32" \
    CMAKE_FIND_ROOT_PATH_MODE_PROGRAM="NEVER" \
    CMAKE_FIND_ROOT_PATH_MODE_LIBRARY="ONLY" \
    CMAKE_FIND_ROOT_PATH_MODE_INCLUDE="ONLY" \
    TARGET="x86_64-pc-windows-gnu" 
