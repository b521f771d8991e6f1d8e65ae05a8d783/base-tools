FROM docker.io/swift:bookworm

RUN apt update && apt upgrade -y && apt install -y gnustep-gui-runtime
