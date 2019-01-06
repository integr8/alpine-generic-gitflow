#!/bin/bash
# set -e

: ${FILE_NAME:="package.json"}
: ${SOURCE_PATH:=""}

change_version(){
    cat $SOURCE_PATH/$FILE_NAME | jq ".version = \"$1\"" > $SOURCE_PATH/bumped.json
    mv $SOURCE_PATH/bumped.json $SOURCE_PATH/package.json
}

change_version $1