FROM docker.visual-craft.com/php7.2-build

ARG PHP_URL="https://secure.php.net/get/php-7.2.15.tar.xz/from/this/mirror"
ARG PHP_CHECKSUM="75e90012faef700dffb29311f3d24fa25f1a5e0f70254a9b8d5c794e25e938ce"

ARG PHP_DIR="/app/php"
ARG PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ARG PHP_CPPFLAGS="$PHP_CFLAGS"
ARG PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

ARG COMPOSER_URL="https://getcomposer.org/download/1.7.3/composer.phar"
ARG COMPOSER_CHECKSUM="bc6cbcd2c0fbc03c7ab87442b5f1fbc9407f0b9900bddc10d755bdc81bbe7b6e"

ARG CRONTAB_MANAGER_URL="https://server.task-tracker.org/dist/crontab-manager-0.2.0.phar"
ARG CRONTAB_MANAGER_CHECKSUM="968f07a2ce02d64edab84710eb5c5e3969cc8ec0b484b795a4b4a4712560d3ad"

ARG NODE_URL="https://nodejs.org/dist/v11.1.0/node-v11.1.0-linux-x64.tar.xz"
ARG NODE_CHECKSUM="c70419674d932452017556080264de2b6d1105c112647dd1dd495b739456dd91"

USER app

RUN set -ex; \
    wget "$PHP_URL" -O "/tmp/php.tar.xz"; \
    echo "$PHP_CHECKSUM /tmp/php.tar.xz" | sha256sum -c -; \
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
    wget "$COMPOSER_URL" -O "/app/bin/composer"; \
    echo "$COMPOSER_CHECKSUM /app/bin/composer" | sha256sum -c -; \
    chmod +x "/app/bin/composer"; \
    wget "$CRONTAB_MANAGER_URL" -O "/app/bin/crontab-manager"; \
    echo "$CRONTAB_MANAGER_CHECKSUM /app/bin/crontab-manager" | sha256sum -c -; \
    chmod +x "/app/bin/crontab-manager"; \
    echo "\$HOME/bin" >> "/app/.paths"; \
    wget "$NODE_URL" -O "/tmp/node.tar.xz"; \
    echo "$NODE_CHECKSUM /tmp/node.tar.xz" | sha256sum -c -; \
    mkdir "/app/node"; \
    tar -Jxf "/tmp/node.tar.xz" -C "/app/node" --strip-components=1; \
    echo "\$HOME/node/bin" >> "/app/.paths"; \
    wget "https://raw.githubusercontent.com/Visual-Craft/supervisor-setup/master/supervisor-setup" -O "/tmp/supervisor-setup"; \
    chmod +x "/tmp/supervisor-setup"; \
    rm -f "/app/.wget-hsts";



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
COPY --chown=app:app "config/php-fpm-pool.conf" "/app/php/etc/php-fpm.d/main.conf"
COPY "config/nginx.conf" "/etc/nginx/nginx.conf"
COPY "config/rsyslog/rsyslog.conf" "/etc/rsyslog.conf"
COPY "config/supervisor/"* "/etc/supervisor/conf.d/"

RUN set -ex; \
    "/tmp/supervisor-setup" -e app; \
    su - app -c ' \
        echo "\$HOME/.supervisor/bin" >> "/app/.paths"; \
        "/app/.supervisor/bin/sv-create" "php-fpm" "/app/php/sbin/php-fpm -F"; \
        mkdir -p "/app/php/etc/conf.d"; \
    ';

EXPOSE 80/tcp
ENTRYPOINT ["/usr/bin/python", "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
