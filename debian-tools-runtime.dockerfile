FROM docker.io/debian:stable-slim
ENV PATH="$PATH:/root/.local/bin/"

RUN groupadd -r wheel && useradd -r -g wheel user
RUN apt update && apt upgrade -y \
    && apt -y --no-install-recommends install dpkg-dev fakeroot sq libalgorithm-merge-perl libalgorithm-diff-xs-perl \
    && apt install -y libswiftlang gnustep-gui-runtime curl nix
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
