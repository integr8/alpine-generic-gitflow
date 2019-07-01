#!/bin/bash

PATH=$PATH:~/.local/bin

export SOURCE_PATH='/opt/source'
export BINARY_PATH=$(dirname "$0")

cd $SOURCE_PATH

. $BINARY_PATH/check.sh
. $BINARY_PATH/api.sh
. $BINARY_PATH/utils.sh
. $BINARY_PATH/source.sh
. $BINARY_PATH/version_bumper.sh

git config gitflow.branch.develop development
git-flow init -d &> /dev/null

case $1 in
  feature)
    . $BINARY_PATH/wrapper/feature.sh
  ;;
  release)
    . $BINARY_PATH/wrapper/release.sh
  ;;
  hotfix)
    . $BINARY_PATH/wrapper/hotfix.sh
  ;;
  bugfix)
    . $BINARY_PATH/wrapper/bugfix.sh
  ;;
  help) echo support ;;
  *) echo 'Show me how it works' ;;
esac
