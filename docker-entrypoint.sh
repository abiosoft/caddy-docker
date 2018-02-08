#!/bin/bash

rm -f /etc/caddy/Caddyfile
for each in $(find /docker-entrypoint.d/ | sort -n) ; do
  case $each in
    *.sh)
      source "$each" >> /etc/caddy/Caddyfile
      ;;
    *.conf)
      cat "$each" >> /etc/caddy/Caddyfile
      ;;
  esac
done

exec $@
