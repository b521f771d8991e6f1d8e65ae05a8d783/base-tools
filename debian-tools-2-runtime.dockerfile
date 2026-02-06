FROM debian:trixie-slim

RUN apt update && apt upgrade -y && apt install -y libswiftlang postgresql
