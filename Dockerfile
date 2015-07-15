FROM alpine:3.1
MAINTAINER Abiola Ibrahim <abiola89@gmail.com>

RUN apk add --update openssh-client git

RUN mkdir /caddysrc \
&& curl -sL -o /caddysrc/caddy_linux_amd64.zip "http://caddyserver.com/download/build?os=linux&arch=amd64&features=git" \
&& unzip /caddysrc/caddy_linux_amd64.zip -d /caddysrc \
&& mv /caddysrc/caddy /usr/bin/caddy \
&& chmod 755 /usr/bin/caddy \
&& rm -rf /caddysrc \
&& printf "0.0.0.0\nbrowse" > /etc/Caddyfile

RUN mkdir /srv

EXPOSE 2015

WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
