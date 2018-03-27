#!/bin/bash

rm -f /etc/caddy/Caddyfile
case $CADDY_GENERATE_CONFIG in
  yes|true)
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
    ;;
  *)
    echo "Using Provided Caddyfile instead of generating it"
    cp /etc/Caddyfile /etc/caddy/Caddyfile
    ;;
esac

exec $@
