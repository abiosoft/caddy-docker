#!/bin/sh

VERSION=${VERSION:-"1.0.3"}
TELEMETRY=${ENABLE_TELEMETRY:-"true"}
IMPORT="github.com/caddyserver/caddy"

# version <1.0.1 needs to use old import path
new_import=true
if [ "$(echo $VERSION | cut -c1)" -eq 0 ] 2>/dev/null || [ "$VERSION" = "1.0.0" ]; then 
    IMPORT="github.com/mholt/caddy" && new_import=false
fi

# add `v` prefix for version numbers
[ "$(echo $VERSION | cut -c1)" -ge 0 ] 2>/dev/null && VERSION="v$VERSION"

stage() {
    STAGE="$1"
    echo
    echo starting stage: $STAGE
}

end_stage() {
    if [ $? -ne 0 ]; then
        >&2 echo error at \'$STAGE\'
        exit 1
    fi
    echo finished stage: $STAGE ✓
    echo
}

use_new_import() (
    cd $1
    find . -name '*.go' | while read -r f; do
        sed -i.bak 's/\/mholt\/caddy/\/caddyserver\/caddy/g' $f && rm $f.bak
    done
)

get_package() {
    # go module require special dns handling
    if $go_mod && [ -f /dnsproviders/$1/$1.go ]; then
        mkdir -p /caddy/dnsproviders/$1
        cp -r /dnsproviders/$1/$1.go /caddy/dnsproviders/$1/$1.go
        echo "caddy/dnsproviders/$1"
    else
        GO111MODULE=off GOOS=linux GOARCH=amd64 caddyplug package $1 2> /dev/null
    fi
}

dns_plugins() {
    git clone https://github.com/caddyserver/dnsproviders /dnsproviders
    # temp hack for repo rename
    if $new_import; then use_new_import /dnsproviders; fi
}

plugins() {
    mkdir -p /plugins
    for plugin in $(echo $PLUGINS | tr "," " "); do \
        import_package=$(get_package $plugin)
        $go_mod || go get -v "$import_package" ; # not needed for modules
        $go_mod && package="main" || package="caddyhttp"
        printf "package $package\nimport _ \"$import_package\"" > \
            /plugins/$plugin.go ; \
    done
}

module() {
    mkdir -p /caddy
    cd /caddy # build dir

    # setup module
    go mod init caddy
    go get -v $IMPORT@$VERSION

    # plugins
    cp -r /plugins/. .

    # temp hack for repo rename
    go get -v -d # download possible plugin deps
    if $new_import; then use_new_import /go/pkg/mod; fi

    # main and telemetry
    cat > main.go <<EOF
    package main
    import "$IMPORT/caddy/caddymain"
    import "os"
    func main() {
        switch os.Getenv("ENABLE_TELEMETRY") {
        case "0", "false":
            caddymain.EnableTelemetry = false
        case "1", "true":
            caddymain.EnableTelemetry = true
        default:
            caddymain.EnableTelemetry = $TELEMETRY
        }
        caddymain.Run()
    }
EOF
}

legacy() {
    cd /go/src/$IMPORT/caddy # build dir

    # plugins
    cp -r /plugins/. ../caddyhttp

    # telemetry
    run_file="/go/src/$IMPORT/caddy/caddymain/run.go"
    if [ "$TELEMETRY" = "false" ]; then
        cat > "$run_file.disablestats.go" <<EOF
        package caddymain
        import "os"
        func init() {
            switch os.Getenv("ENABLE_TELEMETRY") {
            case "0", "false":
                EnableTelemetry = false
            case "1", "true":
                EnableTelemetry = true
            default:
                EnableTelemetry = false
            }
        }
EOF
    fi
}

# caddy source
stage "fetching caddy source"
git clone https://github.com/caddyserver/caddy -b "$VERSION" /go/src/$IMPORT \
    && cd /go/src/$IMPORT
end_stage

# plugin helper
stage "installing plugin helper"
GOOS=linux GOARCH=amd64 go get -v github.com/abiosoft/caddyplug/caddyplug
end_stage

# check for modules support
go_mod=false
[ -f /go/src/$IMPORT/go.mod ] && export GO111MODULE=on && go_mod=true

# dns plugins
stage "fetching dns plugin sources"
dns_plugins
end_stage

# generate plugins
stage "generating plugins"
plugins
end_stage

# add plugins and telemetry
stage "customising plugins and telemetry"
if $go_mod; then module; else legacy; fi
end_stage

# build
stage "building caddy"
CGO_ENABLED=0 go build -o caddy
end_stage

# copy binary
stage "copying binary"
mkdir -p /install \
    && mv caddy /install \
    && /install/caddy -version
end_stage

echo "installed caddy version $VERSION at /install/caddy"
