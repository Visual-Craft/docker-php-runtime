FROM debian:buster

RUN set -ex; \
    DEBIAN_FRONTEND=noninteractive apt update -y; \
    DEBIAN_FRONTEND=noninteractive apt upgrade -y; \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
        supervisor \
        nginx-full \
        libxslt1.1 \
        libargon2-1 \
        libreadline7 \
        libncurses6 \
        libssl1.1 \
        libcurl4 \
        libzip4 \
        libsodium23 \
    ; \
    useradd -m "app" -d "/app" -s "/bin/bash"; \
    rm -rf "/var/lib/apt/lists/"*;
