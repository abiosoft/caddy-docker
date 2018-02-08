offset=0
while true; do
  BASEVAR="CADDY_ENTRY${offset}"
  HOSTNAME="${BASEVAR}_HOSTNAME"
  if [ -z ${!HOSTNAME} ]; then
    break
  fi
  echo "${!HOSTNAME} {"
  for each in $(find /docker-entrypoint.d/40-listen-points/ | sort -n); do
    case $each in
      *.part)
        source $each
        ;;
    esac
  done
  echo "}"
  offset=$((offset + 1))
done
