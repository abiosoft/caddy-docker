# builder

Docker image for building Caddy binaries.

## Usage

Example

```
docker run --rm -v $(pwd):/install -e PLUGINS=git,filebrowser abiosoft/caddy:builder

```

### Volumes

- `/install` - Mount a volume to save the Caddy binary e.g. `-v $(pwd):/install`

### Environment Variables

- `PLUGINS` - comma separated Caddy plugins. e.g. `-e PLUGINS=git,filebrowser,linode`
- `VERSION` - Caddy version, repository tag or branch. Default `0.11.5`
- `ENABLE_TELEMETRY` - Enable telemetry stats. Options `true`|`false`. Default `true`
- `GOOS`, `GOARCH` and `GOARM` are all supported. Default `GOOS=linux`, `GOARCH=amd64`
