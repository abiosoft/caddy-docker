# caddy

A [Docker](https://docker.com) image for [Caddy](https://caddyserver.com). This image includes [git](https://caddyserver.com/docs/http.git), [filebrowser](https://caddyserver.com/docs/http.filebrowser), [cors](https://caddyserver.com/docs/http.cors), [realip](https://caddyserver.com/docs/http.realip), [expires](https://caddyserver.com/docs/http.expires) and [cache](https://caddyserver.com/docs/http.cache) plugins.

Plugins can be configured via the [`plugins` build arg](#custom-plugins).

[![](https://images.microbadger.com/badges/image/abiosoft/caddy.svg)](https://microbadger.com/images/abiosoft/caddy "Get your own image badge on microbadger.com")
[![](https://img.shields.io/badge/version-0.11.5-blue.svg)](https://github.com/mholt/caddy/tree/v0.11.5)

Check [abiosoft/caddy:builder](https://github.com/abiosoft/caddy-docker/blob/master/BUILDER.md) for generating cross-platform Caddy binaries.

### License

This image is built from [source code](https://github.com/mholt/caddy). As such, it is subject to the project's [Apache 2.0 license](https://github.com/mholt/caddy/blob/baf6db5b570e36ea2fee30d50f879255a5895370/LICENSE.txt), but it neither contains nor is subject to [the EULA for Caddy's official binary distributions](https://github.com/mholt/caddy/blob/545fa844bbd188c1e5bff6926e5c410e695571a0/dist/EULA.txt).

### Let's Encrypt Subscriber Agreement

Caddy may prompt to agree to [Let's Encrypt Subscriber Agreement](https://letsencrypt.org/documents/2017.11.15-LE-SA-v1.2.pdf). This is configurable with `ACME_AGREE` environment variable. Set it to true to agree. `ACME_AGREE=true`.

### Telemetry Stats

Starting from `v0.11.0`, [Telemetry stats](https://caddyserver.com/docs/telemetry) are submitted to Caddy by default. To use Caddy without telemetry, use the `:no-stats` or `:<version>-no-stats` tags. e.g. `:0.11.0-no-stats`, `:0.11.0-php-no-stats`.

## Getting Started

```sh
$ docker run -d -p 2015:2015 abiosoft/caddy
```

Point your browser to `http://127.0.0.1:2015`.

> Be aware! If you don't bind mount the location certificates are saved to, you may hit Let's Encrypt rate [limits](https://letsencrypt.org/docs/rate-limits/) rending further certificate generation or renewal disallowed (for a fixed period)! See "Saving Certificates" below!

### Saving Certificates

Save certificates on host machine to prevent regeneration every time container starts.
Let's Encrypt has [rate limit](https://community.letsencrypt.org/t/rate-limits-for-lets-encrypt/6769).

```sh
$ docker run -d \
    -v $(pwd)/Caddyfile:/etc/Caddyfile \
    -v $HOME/.caddy:/root/.caddy \
    -p 80:80 -p 443:443 \
    abiosoft/caddy
```

Here, `/root/.caddy` is the location _inside_ the container where caddy will save certificates.

Additionally, you can use an _environment variable_ to define the exact location caddy should save generated certificates:

```sh
$ docker run -d \
    -e "CADDYPATH=/etc/caddycerts" \
    -v $HOME/.caddy:/etc/caddycerts \
    -p 80:80 -p 443:443 \
    abiosoft/caddy
```

Above, we utilize the `CADDYPATH` environment variable to define a different location inside the container for
certificates to be stored. This is probably the safest option as it ensures any future docker image changes don't interfere with your ability to save certificates!

### PHP

`:[<version>-]php` variant of this image bundles PHP-FPM alongside essential php extensions and [composer](https://getcomposer.org). e.g. `:php`, `:0.10.14-php`

```sh
$ docker run -d -p 2015:2015 abiosoft/caddy:php
```

Point your browser to `http://127.0.0.1:2015` and you will see a php info page.

##### Local php source

Replace `/path/to/php/src` with your php sources directory.

```sh
$ docker run -d -v /path/to/php/src:/srv -p 2015:2015 abiosoft/caddy:php
```

Point your browser to `http://127.0.0.1:2015`.

##### Note

Your `Caddyfile` must include the line `on startup php-fpm7`. For Caddy to be PID 1 in the container, php-fpm7 could not be started.

### Using git sources

Caddy can serve sites from git repository using [git](https://caddyserver.com/docs/http.git) plugin.

##### Create Caddyfile

Replace `github.com/abiosoft/webtest` with your repository.

```sh
$ printf "0.0.0.0\nroot src\ngit github.com/abiosoft/webtest" > Caddyfile
```

##### Run the image

```sh
$ docker run -d -v $(pwd)/Caddyfile:/etc/Caddyfile -p 2015:2015 abiosoft/caddy
```

Point your browser to `http://127.0.0.1:2015`.

## Custom plugins

You can build a docker image with custom plugins by specifying `plugins` build arg as shown in the example below.

```
docker build --build-arg \
    plugins=git,linode \
    github.com/abiosoft/caddy-docker.git
```

## Usage

#### Default Caddyfile

The image contains a default Caddyfile.

```
0.0.0.0
browse
fastcgi / 127.0.0.1:9000 php # php variant only
on startup php-fpm7 # php variant only
```

The last 2 lines are only present in the php variant.

#### Paths in container

Caddyfile: `/etc/Caddyfile`

Sites root: `/srv`

#### Using local Caddyfile and sites root

Replace `/path/to/Caddyfile` and `/path/to/sites/root` accordingly.

```sh
$ docker run -d \
    -v /path/to/sites/root:/srv \
    -v path/to/Caddyfile:/etc/Caddyfile \
    -p 2015:2015 \
    abiosoft/caddy
```

### Let's Encrypt Auto SSL

**Note** that this does not work on local environments.

Use a valid domain and add email to your Caddyfile to avoid prompt at runtime.
Replace `mydomain.com` with your domain and `user@host.com` with your email.

```
mydomain.com
tls user@host.com
```

##### Run the image

You can change the the ports if ports 80 and 443 are not available on host. e.g. 81:80, 444:443

```sh
$ docker run -d \
    -v $(pwd)/Caddyfile:/etc/Caddyfile \
    -p 80:80 -p 443:443 \
    abiosoft/caddy
```
