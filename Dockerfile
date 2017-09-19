#
# Builder
#
FROM golang:1.8.3-alpine as builder

ARG version="0.10.9"

RUN apk add --no-cache curl git

# caddy
RUN git clone https://github.com/mholt/caddy -b "v${version}" /go/src/github.com/mholt/caddy \
    && cd /go/src/github.com/mholt/caddy \
    && git checkout -b "v${version}"

# git plugin
RUN git clone https://github.com/abiosoft/caddy-git /go/src/github.com/abiosoft/caddy-git

# integrate git plugin
RUN printf 'package caddyhttp\nimport _ "github.com/abiosoft/caddy-git"' > \
    /go/src/github.com/mholt/caddy/caddyhttp/git.go

# builder dependency
RUN git clone https://github.com/caddyserver/builds /go/src/github.com/caddyserver/builds

# build
RUN cd /go/src/github.com/mholt/caddy/caddy \
    && git checkout -f \
    && go run build.go \
    && mv caddy /go/bin

#
# Final stage
#
FROM alpine:3.6
LABEL maintainer "Abiola Ibrahim <abiola89@gmail.com>"

LABEL caddy_version="0.10.9"

RUN apk add --no-cache openssh-client git

# install caddy
COPY --from=builder /go/bin/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins | grep http.git

EXPOSE 80 443 2015
VOLUME /root/.caddy /srv
WORKDIR /srv

COPY Caddyfile /etc/Caddyfile
COPY index.html /srv/index.html

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]
