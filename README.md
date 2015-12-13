# caddy-docker

A [Docker](http://docker.com) image for [Caddy](http://caddyserver.com). This image includes the [git](http://caddyserver.com/docs/git) addon.

[![](https://badge.imagelayers.io/abiosoft/caddy:latest.svg)](https://imagelayers.io/?images=abiosoft/caddy:latest 'Get your own badge on imagelayers.io')

## Getting Started

### Serve current directory

```
$ docker run -d -v `pwd`:/srv -p 2015:2015 abiosoft/caddy
```

Point your browser to `http://127.0.0.1:2015`.

### Using git sources

Caddy can serve sites from git repository using [git](https://caddyserver.com/docs/git) middleware.

##### Create Caddyfile

Replace `github.com/abiosoft/webtest` with your repository.

```
$ printf "0.0.0.0\ngit github.com/abiosoft/webtest" > Caddyfile
```

##### Run the image

```
$ docker run -d -v `pwd`/Caddyfile:/etc/Caddyfile -p 2015:2015 abiosoft/caddy
```
Point your browser to `http://127.0.0.1:2015`.

## Usage

#### Default Caddyfile

The image contains a default Caddyfile.

```
0.0.0.0
browse
```

#### Paths in container

Caddyfile: `/etc/Caddyfile`

Sites root: `/srv`

#### Using local Caddyfile and sites root

Replace `/path/to/Caddyfile` and `/path/to/sites/root` accordingly.

```
$ docker run -d -v /path/to/sites/root:/srv -v path/to/Caddyfile:/etc/Caddyfile -p 2015:2015 abiosoft/caddy
```

### Let's Encrypt Auto SSL
**Note** that this does not work on local environments.

Add email to your Caddyfile to avoid prompt at runtime. Replace `user@host.com` with your email.
```
tls user@host.com
```

#### Run the image

You can change the the ports if ports 80 and 443 are not available on host. e.g. 81:80, 444:443

```
$ docker run -d -v /path/to/sites/root:/srv -v `pwd`/Caddyfile:/etc/Caddyfile -p 80:80 -p 443:443 abiosoft/caddy
```

**Optional** but advised. Save certificates on host machine to prevent regeneration every time container starts.

```
$ docker run -d -v /path/to/sites/root:/srv -v `pwd`/Caddyfile:/etc/Caddyfile -v $HOME/.caddy:/root/.caddy -p 80:80 -p 443:443 abiosoft/caddy
```
