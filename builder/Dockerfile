FROM golang:1.9.1-alpine

RUN apk add --no-cache git

COPY builder.sh /usr/bin/builder.sh

CMD ["/bin/sh", "/usr/bin/builder.sh"]

