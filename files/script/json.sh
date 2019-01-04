#!/bin/bash
# set -e

: ${FILE_PATH:="package.json"}

change_version(){
    cat $FILE_PATH | jq ".version = \"$1\"" > bumped.json
    mv bumped.json package.json
}

change_version $1