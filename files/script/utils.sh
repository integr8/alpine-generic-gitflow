#!/bin/bash
  
get_release_message() {
  reference=$1
  release_note_file="/tmp/release-note-`get_current_release_version`"
  release_note_message=`git --no-pager log  --pretty='format: \* [ %h ] %s \n' --no-merges $reference..HEAD`

  echo -e $release_note_message > $release_note_file
  echo $release_note_message
}

