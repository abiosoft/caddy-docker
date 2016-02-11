FROM alpine:3.2
MAINTAINER Abiola Ibrahim <abiola89@gmail.com>

LABEL caddy_version="0.8.1" architecture="amd64"

RUN apk add --update openssh-client git tar php-fpm

# essential php libs
RUN apk add php-curl php-gd php-zip php-iconv php-sqlite3 php-mysql php-mysqli php-json

# allow environment variable access.
RUN echo "clear_env = no" >> /etc/php/php-fpm.conf

RUN mkdir /caddysrc \
&& curl -sL -o /caddysrc/caddy_linux_amd64.tar.gz "http://caddyserver.com/download/build?os=linux&arch=amd64&features=git" \
&& tar -xf /caddysrc/caddy_linux_amd64.tar.gz -C /caddysrc \
&& mv /caddysrc/caddy /usr/bin/caddy \
&& chmod 755 /usr/bin/caddy \
&& rm -rf /caddysrc \
&& printf "0.0.0.0\nfastcgi / 127.0.0.1:9000 php\nbrowse\nstartup php-fpm" > /etc/Caddyfile

RUN mkdir /srv \
&& printf "<?php phpinfo(); ?>" > /srv/index.php

EXPOSE 2015
EXPOSE 443
EXPOSE 80

WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
