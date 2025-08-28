FROM docker.io/ubuntu:jammy

RUN apt update && apt upgrade -y && apt install -y wget
RUN wget https://github.com/darlinghq/darling/releases/download/v0.1.20230310_update_sources_11_5/darling_0.1.20230310.jammy_amd64.deb && apt install ./darling_0.1.20230310.jammy_amd64.deb
