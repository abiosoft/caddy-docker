FROM alpine:3.5
LABEL maintainer "Abiola Ibrahim <abiola89@gmail.com>"

LABEL caddy_version="0.10.6" architecture="amd64"

ARG plugins=http.git

RUN apk add --no-cache openssh-client git tar php7-fpm curl

# essential php libs
RUN apk add --no-cache php7-curl php7-dom php7-gd php7-ctype php7-zip php7-xml php7-iconv php7-sqlite3 php7-mysqli php7-pgsql php7-json php7-phar php7-openssl php7-pdo php7-pdo_mysql php7-session php7-mbstring php7-bcmath

# symblink php7 to php
RUN ln -sf /usr/bin/php7 /usr/bin/php

# symlink php-fpm7 to php-fpm
RUN ln -sf /usr/bin/php-fpm7 /usr/bin/php-fpm

# composer
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" \
      "https://getcomposer.org/installer" \
    | php -- --install-dir=/usr/bin --filename=composer

# allow environment variable access.
RUN echo "clear_env = no" >> /etc/php7/php-fpm.conf

# install caddy
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/linux/amd64?plugins=${plugins}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && /usr/bin/caddy -version

EXPOSE 80 443 2015
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.php /srv/index.php

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]
