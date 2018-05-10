builder
=======

Docker image for building Caddy binaries.

## Usage

Example

```
docker run --rm -v $(pwd):/install -e PLUGINS=git,filemanager abiosoft/caddy:builder

```

### Volumes

* `/install` - Mount a volume to save the Caddy binary e.g. `-v $(pwd):/install`

### Environment Variables

* `PLUGINS` - comma separated Caddy plugins. e.g. `-e PLUGINS=git,filemanager,linode`
* `VERSION` - Caddy version. Default `0.11.0`
* `ENABLE_TELEMETRY` - Enable telemetry stats. Options `true`|`false`. Default `true`
* `GOOS`, `GOARCH` and `GOARM` are all supported. Default `GOOS=linux`, `GOARCH=amd64`
