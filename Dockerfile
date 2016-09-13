FROM alpine:3.4
MAINTAINER Abiola Ibrahim <abiola89@gmail.com>

LABEL caddy_version="0.9.1" architecture="amd64"

ARG plugins=git

RUN apk add --no-cache openssh-client git libcap tar curl

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=${plugins}" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && addgroup -S caddy \
 && adduser -D -S -s /sbin/nologin -G caddy caddy \
 && setcap cap_net_bind_service=+ep /usr/bin/caddy \
 && /usr/bin/caddy -version

EXPOSE 80 443 2015
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html

# grant necessary permission
RUN chown -R caddy:caddy /srv

USER caddy

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
