# version 0.1.1

FROM debian:stretch-slim

COPY "scripts/setup-paths" "/tmp/setup-paths"
COPY "config/apt/sources.list.d/buster.list" "/etc/apt/sources.list.d"
COPY "config/apt/preferences.d/priority" "/etc/apt/preferences.d"
COPY "config/apt/preferences.d/no-debian-php" "/etc/apt/preferences.d"
COPY "config/apt/apt.conf.d/default-release" "/etc/apt/apt.conf.d"

RUN set -ex; \
    DEBIAN_FRONTEND=noninteractive apt update -y; \
    DEBIAN_FRONTEND=noninteractive apt upgrade -y; \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
        autoconf \
        dpkg-dev \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkg-config \
        re2c \
        ca-certificates \
        xz-utils \
        wget \
        libssl-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        libbz2-dev \
        libreadline-dev \
        libsodium-dev \
        libxslt1-dev \
        libzip-dev \
        libpng-dev \
        libxpm-dev \
        libjpeg-dev \
        libfreetype6-dev \
    ; \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y -t buster \
        libargon2-dev \
    ; \
    useradd -m "app" -d "/app"; \
    chmod a+x "/tmp/setup-paths"; \
    su - app -c "/tmp/setup-paths"; \
    rm -rf "/var/lib/apt/lists/"*;
