#!/bin/bash
  
get_release_message() {
  reference=$1
  release_note_message="Versão `get_current_release_version`\n\n"
  release_note_file="/tmp/release-note-`get_current_release_version`"

  while read -r ; do
    release_note_message="$release_note_message $REPLY\n"; 
  done < <(git log --pretty='format:[ %h ] %s' --no-merges 10.0.0..HEAD)

  echo -e $release_note_message > $release_note_file

  echo $release_note_file
}

