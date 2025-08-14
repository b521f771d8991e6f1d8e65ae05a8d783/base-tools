ARG DEBIAN_VERSION=trixie

FROM docker.io/debian:${DEBIAN_VERSION}-slim
RUN groupadd -r wheel && useradd -r -g wheel user
RUN apt --no-install-recommends install dpkg-dev fakeroot sq libalgorithm-merge-perl libalgorithm-diff-xs-perl
RUN apt update && apt upgrade -y && apt install -y libswiftlang gnustep-gui-runtime
