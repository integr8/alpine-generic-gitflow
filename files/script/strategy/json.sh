#!/bin/bash
# set -e

: ${FILE_NAME:="package.json"}

change_version(){
  echo $( echo $SOURCE_PATH/$FILE_NAME | jq ".version = \"$1\"") > $SOURCE_PATH/package.json
}

change_version $1