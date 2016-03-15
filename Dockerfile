FROM alpine:3.2
MAINTAINER Abiola Ibrahim <abiola89@gmail.com>

LABEL caddy_version="0.8.2" architecture="amd64"

RUN apk add --update openssh-client git tar

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=git" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && /usr/bin/caddy -version

EXPOSE 80 443 2015
VOLUME /srv
WORKDIR /srv

ADD Caddyfile /etc/Caddyfile
ADD index.html /srv/index.html

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
