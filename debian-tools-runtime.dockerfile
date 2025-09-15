FROM docker.io/debian:stable-slim
RUN groupadd -r wheel && useradd -r -g wheel user
RUN apt update && apt upgrade -y \
    && apt -y --no-install-recommends install dpkg-dev fakeroot sq libalgorithm-merge-perl libalgorithm-diff-xs-perl \
    && apt install -y libswiftlang gnustep-gui-runtime curl
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
