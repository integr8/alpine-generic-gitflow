#!/bin/bash
SUBCOMMAND=$2

if [[ "${SUBCOMMAND}" == 'start' ]]; then
  git-flow release start `get_version`
  . $BINARY_PATH/strategy.sh

  git add -A
  git commit -m 'Updating POMs'
  
  git-flow release publish
fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  export GIT_MERGE_AUTOEDIT=no
  git-flow release finish -p -m 'Finishing release'
  unset GIT_MERGE_AUTOEDIT
fi


