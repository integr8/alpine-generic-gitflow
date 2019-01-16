#!/bin/bash
  
get_release_message() {
  reference=$( [[ "$1" == '0.0.0' ]] && echo HEAD || echo $1..HEAD )
  release_note_file="/tmp/release-note-`get_current_release_version`"
  release_note_message=`git --no-pager log  --pretty='format: \* [ %h ] %s \n' --no-merges $reference`

  echo -e $release_note_message > $release_note_file
  echo $release_note_message
}

