FROM debian:buster

COPY "scripts/setup-paths" "/tmp/setup-paths"

RUN set -ex; \
    DEBIAN_FRONTEND=noninteractive apt update -y; \
    DEBIAN_FRONTEND=noninteractive apt upgrade -y; \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
        ca-certificates \
        build-essential \
        autoconf \
        wget \
        file \
        libssl-dev \
        libxml2-dev \
        libcurl4-openssl-dev \
        libbz2-dev \
        libreadline-dev \
        libsodium-dev \
        libargon2-dev \
        libxslt1-dev \
        libzip-dev \
        libpng-dev \
        libxpm-dev \
        libjpeg-dev \
        libfreetype6-dev \
    ; \
    useradd -m "app" -d "/app"; \
    chmod a+x "/tmp/setup-paths"; \
    su - app -c "/tmp/setup-paths"; \
    rm -rf "/var/lib/apt/lists/"* "/usr/share/doc" "/usr/share/locale";
