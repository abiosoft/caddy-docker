# caddy-docker

A [Docker](http://docker.com) image for [Caddy](http://caddyserver.com). This image includes the [git](http://caddyserver.com/docs/git) addon.

[![](https://badge.imagelayers.io/abiosoft/caddy:latest.svg)](https://imagelayers.io/?images=abiosoft/caddy:latest 'Get your own badge on imagelayers.io')

## Getting Started

### Serve current directory

```sh
$ docker run -d -v $(pwd):/srv -p 2015:2015 abiosoft/caddy
```

Point your browser to `http://127.0.0.1:2015`.

### PHP
`:[<version>-]php` variant of this image bundles PHP-FPM. e.g. `:php`, `:0.8.0-php`
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
Your `Caddyfile` must include the line `startup php-fpm`. This is necessary for Caddy to be PID 1 in the container.

### Using git sources

Caddy can serve sites from git repository using [git](https://caddyserver.com/docs/git) middleware.

##### Create Caddyfile

Replace `github.com/abiosoft/webtest` with your repository.

```sh
$ printf "0.0.0.0\ngit github.com/abiosoft/webtest" > Caddyfile
```

##### Run the image

```sh
$ docker run -d -v $(pwd)/Caddyfile:/etc/Caddyfile -p 2015:2015 abiosoft/caddy
```
Point your browser to `http://127.0.0.1:2015`.

## Usage

#### Default Caddyfile

The image contains a default Caddyfile.

```
0.0.0.0
browse
fastcgi / 127.0.0.1:9000 php # php variant only
startup php-fpm # php variant only
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

Add email to your Caddyfile to avoid prompt at runtime. Replace `user@host.com` with your email.
```
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

**Optional** but advised. Save certificates on host machine to prevent regeneration every time container starts.

```sh
$ docker run -d \
    -v $(pwd)/Caddyfile:/etc/Caddyfile \
    -v $HOME/.caddy:/root/.caddy \
    -p 80:80 -p 443:443 \
    abiosoft/caddy
```
