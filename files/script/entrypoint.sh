#!/bin/bash
set -e

export SOURCE_PATH='/opt/source'
export BINARY_PATH=$(dirname "$0")

source $BINARY_PATH/source.sh
source $BINARY_PATH/bump.sh

printf "\n\n" | git flow init

case $1 in
  feature) echo feature ;;
  bugfix) echo bugfix ;;
  release)
    source $BINARY_PATH/wrapper/release.sh
  ;;
  hotfix) echo hotfix ;;
  support) echo support ;;
  *) echo 'sho me how it works' ;;
esac