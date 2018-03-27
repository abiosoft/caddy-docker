#
# Builder
#
FROM abiosoft/caddy:builder as builder

ARG version="0.10.12"
ARG plugins="git"

RUN VERSION=${version} PLUGINS=${plugins} /bin/sh /usr/bin/builder.sh

#
# Final stage
#
FROM alpine:3.7
LABEL maintainer "Abiola Ibrahim <abiola89@gmail.com>"

ARG version="0.10.12"
LABEL caddy_version="$version"

RUN apk add --no-cache openssh-client git bash

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv /etc/caddy
WORKDIR /srv

COPY index.html /srv/index.html
COPY docker-entrypoint.sh /
COPY docker-entrypoint.d /docker-entrypoint.d/

ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]
CMD ["/usr/bin/caddy", "--conf", "/etc/caddy/Caddyfile", "--log", "stdout"]
