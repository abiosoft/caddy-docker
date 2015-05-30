FROM alpine:3.1
MAINTAINER Abiola Ibrahim <abiola89@gmail.com>

RUN apk add --update openssh-client git

RUN mkdir /caddysrc \
&& cd /caddysrc \
&& curl -sLO https://github.com/mholt/caddy/releases/download/v0.7.0/caddy_linux_amd64.zip\
&& unzip caddy_linux_amd64.zip \
&& mv caddy /usr/bin/caddy \
&& chmod 755 /usr/bin/caddy \
&& rm -rf /caddysrc \
&& printf "0.0.0.0\nbrowse" > /etc/Caddyfile

RUN mkdir /srv

EXPOSE 2015

WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
