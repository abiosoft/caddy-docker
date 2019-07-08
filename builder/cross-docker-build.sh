#!/bin/bash

source build.config

set -e

init_multiarch_builder(){
  if [ ! -d .tmp/docker-multiarch-builder ]; then
    git clone https://github.com/lobradov/docker-multiarch-builder.git .tmp/docker-multiarch-builder
  fi

  if [ ! -d .tmp/docker-cli ]; then
    echo "INFO: Running .tmp/docker-multiarch-builder/run-once.sh"
    pushd .tmp/docker-multiarch-builder
    sudo ./run-once.sh
    popd

    # Resets ownership of those files
    sudo mv .tmp/docker-multiarch-builder/cli/build .tmp/docker-cli
    sudo chown `id -u`:`id -g` -R .tmp/docker-cli
  else
    echo "INFO: Ignoring docker-multiarch-builder/run-once.sh because .tmp/docker-multiarch-builder/cli/build already exists"
  fi
}

download_qemu(){
  if [[ $(uname -s) != "Darwin" ]]; then
    echo INFO: Downloading qemu static
    mkdir -p .tmp/qemu .tmp/qemu-tar
    for target_arch in ${QEMU_ARCHS}; do
      [[ -f .tmp/qemu/qemu-${target_arch}-static ]] \
      || wget -N -P .tmp/qemu-tar https://github.com/multiarch/qemu-user-static/releases/download/${QEMU_VERSION}/x86_64_qemu-${target_arch}-static.tar.gz \

      # extracts the tar file
      [[ -f .tmp/qemu-tar/x86_64_qemu-${target_arch}-static.tar.gz ]] \
      && tar -xvf .tmp/qemu-tar/x86_64_qemu-${target_arch}-static.tar.gz -C .tmp/qemu
    done
    rm -rf .tmp/qemu-tar
  else
    echo INFO: Running on Mac, skipping Qemu build.
  fi
}

cross_build(){
  sudo .tmp/docker-multiarch-builder/build.sh
}

init_multiarch_builder
download_qemu
cross_build
