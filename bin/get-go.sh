#!/usr/bin/env bash

set -euo pipefail

if test -f /etc/alpine-release ; then
	apk add --no-cache git make musl-dev go
fi

# Configure Go
if [ ! -z "${GOROOT:-}" ]; then
  # goroot is already set...
  echo "GOROOT=$GOROOT"
elif test -d $HOME/sdk/go ; then
	export GOROOT=$HOME/sdk/go
elif test -d /usr/lib/golang ; then
	export GOROOT=/usr/lib/golang
elif test -d /usr/lib/go ; then
	export GOROOT=/usr/lib/go
elif test -d /usr/local/go ; then
	export GOROOT=/usr/local/go
else
	echo "Install a golang package from your package manager first (exiting)"
	exit 1
fi
export GOPATH=/go
export PATH=/go/bin:$PATH

mkdir -p ${GOPATH}/src ${GOPATH}/bin

# Install Glide
#RUN go get -u github.com/Masterminds/glide/...

#WORKDIR $GOPATH

#CMD ["make"]
# source: https://stackoverflow.com/a/53405005/661659

version=1.15.3
echo "Installing go $version (with CGO_ENABLED=0)"

set -x

go get golang.org/dl/go${version}
go${version} download
rm $HOME/sdk/go${version}/bin/go
cd $HOME/sdk/go${version}/src
CGO_ENABLED=0 ./all.bash
rm $HOME/go/bin/go$version
ln -sf $HOME/sdk/go${version} $HOME/sdk/go
