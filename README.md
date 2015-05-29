# caddy-docker

A [Docker](http://docker.com) image for [Caddy](http://caddyserver.com).

### Getting Started

#### Create a Caddyfile

Sample Caddyfile using [git](https://caddyserver.com/docs/git) middleware.

```
$ printf "0.0.0.0\ngit github.com/abiosoft/webtest" > Caddyfile
```

#### Run the image

```
$ docker run -d -v `pwd`/Caddyfile:/etc/Caddyfile -p 2015:2015 abiosoft/caddy
```

Point your browser to `http://127.0.0.1:2015`.

### Usage

#### Paths in container

Caddyfile: `/etc/Caddyfile`

Server root: `/srv`

#### Serving local sites

Serve `/var/www/html/mysite` with Caddy

```
$ docker run -d -v /var/www/html/mysite:/srv -v path/to/Caddyfile:/etc/Caddyfile -p 2015:2015 abiosoft/caddy
```
