FROM golang:1.10-alpine

RUN apk add --no-cache git

COPY builder.sh /usr/bin/builder.sh

CMD ["/bin/sh", "/usr/bin/builder.sh"]

