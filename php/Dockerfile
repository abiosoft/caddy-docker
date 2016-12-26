FROM alpine:3.4
MAINTAINER Abiola Ibrahim <abiola89@gmail.com>

LABEL caddy_version="0.9.4" architecture="amd64"

ARG plugins=git

RUN apk add --no-cache openssh-client git tar php5-fpm curl

# essential php libs
RUN apk add --no-cache php5-curl php5-gd php5-zip php5-xml php5-iconv php5-sqlite3 php5-mysql php5-mysqli php5-pgsql php5-json php5-phar php5-openssl php5-pdo

# composer
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" \
      "https://getcomposer.org/installer" \
    | php -- --install-dir=/usr/bin --filename=composer

# allow environment variable access.
RUN echo "clear_env = no" >> /etc/php5/php-fpm.conf

# install caddy
RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=${plugins}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \  
 && /usr/bin/caddy -version

EXPOSE 80 443 2015
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.php /srv/index.php

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]
