#!/bin/bash

# set -x 

get_release_message() {
  reference=$( [[ "$1" == '0.0.0' ]] && echo HEAD || echo $1..HEAD )
  release_note_file="/tmp/release-note-`get_current_release_version`"
  release_note_message=`git --no-pager log  --pretty='format: \* [ %h ] %s \n' --no-merges $reference`

  echo -e $release_note_message > $release_note_file
  echo $release_note_message
}

get_uri_info() {
  URI=$1
  FRAGMENT=$2
  
  # echo $URI
  # echo $FRAGMENT

  proto="$(echo $URI | grep :// | sed -e's,^\(.*://\).*,\1,g')"
  url="$(echo ${1/$proto/})"
  user="$(echo $url | grep @ | cut -d@ -f1)"
  hostport="$(echo ${url/$user@/} | cut -d/ -f1)"
  host="$(echo $hostport | sed -e 's,:.*,,g')"
  port="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
  path="$(echo $url | grep / | cut -d/ -f2-)"

  echo "${!FRAGMENT}"
}