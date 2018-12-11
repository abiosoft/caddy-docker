#
# Builder
#
FROM abiosoft/caddy:builder as builder

ARG version="0.11.1"
ARG plugins="git,cors,realip,expires,cache"

# process wrapper
RUN go get -v github.com/abiosoft/parent

RUN VERSION=${version} PLUGINS=${plugins} /bin/sh /usr/bin/builder.sh

#
# compress stage
#
FROM alpine:3.8 as compress

# install upx
RUN set -ex && \
    apk add --update --no-cache \
    upx

# import caddy
COPY --from=builder /install/caddy /install/caddy

# compress & test
# be patient, might takes 10-20 min
# caddy saves approx. from 19.65Mo to 7.45Mo
# overall the docker image is getting smaller by 12Mo
RUN upx --ultra-brute /install/caddy
RUN upx -t /install/caddy
RUN /install/caddy -version
RUN /install/caddy -plugins

#
# Final stage
#
FROM alpine:3.8
LABEL maintainer "Abiola Ibrahim <abiola89@gmail.com>"

ARG version="0.11.1"
LABEL caddy_version="$version"

# Let's Encrypt Agreement
ENV ACME_AGREE="false"

RUN apk add --no-cache openssh-client git

# install caddy
COPY --from=compress /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html

# install process wrapper
COPY --from=builder /go/bin/parent /bin/parent

ENTRYPOINT ["/bin/parent", "caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=$ACME_AGREE"]
