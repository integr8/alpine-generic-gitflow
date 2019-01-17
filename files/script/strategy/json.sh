#!/bin/bash

: ${FILE_NAME:="package.json"}

change_version() {
  cat $SOURCE_PATH/$FILE_NAME | jq -r ".version = \"$next_version\"" > $SOURCE_PATH/new_package.json
  mv -f $SOURCE_PATH/new_package.json $SOURCE_PATH/$FILE_NAME
}