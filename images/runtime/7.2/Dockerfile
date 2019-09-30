# version 0.5.0

FROM docker.visual-craft.com/php7.2-7.3-build:0.1.1

ARG PHP_URL="https://secure.php.net/get/php-7.2.21.tar.xz/from/this/mirror"
ARG PHP_CHECKSUM="de06aff019d8f5079115795bd7d8eedd4cd03daecb62d58abb18f492dd995c95"

ARG PHP_DIR="/app/php"
ARG PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ARG PHP_CPPFLAGS="$PHP_CFLAGS"
ARG PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ARG COMPOSER_URL="https://getcomposer.org/download/1.8.5/composer.phar"
ARG COMPOSER_CHECKSUM="4e4c1cd74b54a26618699f3190e6f5fc63bb308b13fa660f71f2a2df047c0e17"

ARG CRONTAB_MANAGER_URL="https://server.task-tracker.org/dist/crontab-manager-0.2.0.phar"
ARG CRONTAB_MANAGER_CHECKSUM="968f07a2ce02d64edab84710eb5c5e3969cc8ec0b484b795a4b4a4712560d3ad"

ARG NODE_URL="https://nodejs.org/dist/v11.15.0/node-v11.15.0-linux-x64.tar.xz"
ARG NODE_CHECKSUM="17424aef198fa322b93c79217ce7e8cdd264fed40383abbbd3e63c305ce1d7d8"

ARG SUPERVISOR_SETUP_URL="https://raw.githubusercontent.com/Visual-Craft/supervisor-setup/e7897a45057ce874ccff60e6f32929aba961ae7d/supervisor-setup"
ARG SUPERVISOR_SETUP_CHECKSUM="50a6fb29e3113863b0977edfb38ee6788e655784e2fee8fb65b7770d8dd40f16"

USER app

RUN set -ex; \
    wget "$PHP_URL" -O "/tmp/php.tar.xz"; \
    echo "$PHP_CHECKSUM /tmp/php.tar.xz" | sha256sum -c -; \
    wget "$COMPOSER_URL" -O "/tmp/composer"; \
    echo "$COMPOSER_CHECKSUM /tmp/composer" | sha256sum -c -; \
    wget "$CRONTAB_MANAGER_URL" -O "/tmp/crontab-manager"; \
    echo "$CRONTAB_MANAGER_CHECKSUM /tmp/crontab-manager" | sha256sum -c -; \
    wget "$NODE_URL" -O "/tmp/node.tar.xz"; \
    echo "$NODE_CHECKSUM /tmp/node.tar.xz" | sha256sum -c -; \
    wget "$SUPERVISOR_SETUP_URL" -O "/tmp/supervisor-setup"; \
    echo "$SUPERVISOR_SETUP_CHECKSUM /tmp/supervisor-setup" | sha256sum -c -; \
    mkdir "/tmp/php-src"; \
    tar -Jxf "/tmp/php.tar.xz" -C "/tmp/php-src" --strip-components=1; \
    mkdir "$PHP_DIR"; \
    cd "/tmp/php-src"; \
    export \
        CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS" \
    ; \
    ./configure \
        --enable-option-checking=fatal \
        --prefix="$PHP_DIR" \
        --disable-cgi \
        --enable-fpm \
        --enable-bcmath \
        --enable-calendar \
        --enable-intl \
        --enable-mbstring \
        --enable-pcntl \
        --enable-zip \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-sysvmsg \
        --enable-shmop \
        --enable-sockets \
        --enable-opcache \
        --enable-exif \
        --enable-ftp \
        --enable-mysqlnd \
        --enable-opcache \
        --with-pdo-mysql \
        --with-mysqli \
        --with-xmlrpc \
        --with-bz2 \
        --with-curl \
        --with-openssl \
        --with-readline \
        --with-zlib \
        --with-xsl \
        --with-mhash \
        --with-libzip \
        --with-gd=shared \
        --with-freetype-dir=/usr/include/freetype2/freetype \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
        --with-xpm-dir=/usr \
        --with-password-argon2 \
        --with-sodium=shared \
        --with-config-file-path="$PHP_DIR/etc" \
        --with-config-file-scan-dir="$PHP_DIR/etc/conf.d" \
    ; \
    make; \
    make install; \
    cp "/tmp/php-src/php.ini-production" "$PHP_DIR/etc/php.ini"; \
    mv "/app/php/etc/php-fpm.conf.default" "/app/php/etc/php-fpm.conf"; \
    rm "/app/php/etc/php-fpm.d/www.conf.default"; \
    echo "\$HOME/php/bin" >> "/app/.paths"; \
    bash -l -c "pecl install xdebug-2.6.1"; \
    bash -l -c "echo -ne 'no\nno\n' | pecl install redis-4.1.1"; \
    mkdir "/app/bin"; \
    mv "/tmp/composer" "/app/bin/composer"; \
    chmod +x "/app/bin/composer"; \
    mv "/tmp/crontab-manager" "/app/bin/crontab-manager"; \
    chmod +x "/app/bin/crontab-manager"; \
    echo "\$HOME/bin" >> "/app/.paths"; \
    mkdir "/app/node"; \
    tar -Jxf "/tmp/node.tar.xz" -C "/app/node" --strip-components=1; \
    echo "\$HOME/node/bin" >> "/app/.paths"; \
    chmod +x "/tmp/supervisor-setup"; \
    rm -f "/app/.wget-hsts"; \
    find "/app/php/lib/php/extensions/" -type f -name '*.a' -delete;



FROM debian:stretch-slim

COPY "config/apt/sources.list.d/buster.list" "/etc/apt/sources.list.d"
COPY "config/apt/preferences.d/priority" "/etc/apt/preferences.d"
COPY "config/apt/preferences.d/no-debian-php" "/etc/apt/preferences.d"
COPY "config/apt/apt.conf.d/default-release" "/etc/apt/apt.conf.d"

RUN set -ex; \
    DEBIAN_FRONTEND=noninteractive apt update -y; \
    DEBIAN_FRONTEND=noninteractive apt upgrade -y; \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
        supervisor \
        nginx-full \
        cron \
        rsyslog \
        unzip \
        inotify-tools \
        ca-certificates \
        openssl \
        libxslt1.1 \
        libreadline7 \
        libncurses5 \
        libssl1.1 \
        libcurl3 \
        libzip4 \
        libsodium18 \
    ; \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y -t buster \
        libargon2-1 \
    ; \
    useradd -m "app" -d "/app" -s "/bin/bash"; \
    rm -rf "/var/lib/apt/lists/"* "/var/log/apt"; \
    rm -f "/var/log/dpkg.log";

COPY --from=0 "/tmp/supervisor-setup" "/tmp/supervisor-setup"
COPY --from=0 --chown=app:app "/app" "/app"

RUN set -ex; \
    rm -f "/etc/nginx/modules-enabled/"* "/etc/nginx/sites-enabled/"* "/etc/nginx/sites-available/"* ; \
    "/tmp/supervisor-setup" -e app; \
    echo "PATH=/app/.supervisor/bin:/app/node/bin:/app/bin:/app/php/bin:/usr/local/bin:/usr/bin:/bin" | crontab -u app -; \
    su - app -c ' \
        set -ex; \
        echo "\$HOME/.supervisor/bin" >> "/app/.paths"; \
        "/app/.supervisor/bin/sv-create" "php-fpm" "/app/php/sbin/php-fpm -F"; \
        mkdir -p "/app/php/etc/conf.d"; \
    ';

COPY --chown=app:app "config/php/fpm-pool.conf" "/app/php/etc/php-fpm.d/main.conf"
COPY "config/nginx/nginx.conf" "/etc/nginx/nginx.conf"
COPY "config/nginx/sites-available/" "/etc/nginx/sites-available/"
COPY "config/rsyslog/rsyslog.conf" "/etc/rsyslog.conf"
COPY "config/supervisor/" "/etc/supervisor/"
COPY "container-init/container-init" "/usr/sbin/container-init"

RUN set -ex; \
    ln -s "/etc/nginx/sites-available/default.conf" "/etc/nginx/sites-enabled/default.conf"; \
    chmod 0700 "/usr/sbin/container-init"; \
    mkdir -p "/var/lib/container-init";

EXPOSE 80/tcp
ENTRYPOINT ["/usr/bin/python", "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
