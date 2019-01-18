#!/bin/bash
SUBCOMMAND=$2
BUGFIX=$3

if [[ "${SUBCOMMAND}" == 'start' ]]; then
  git checkout `get_current_release_branch`
  git-flow bugfix start $BUGFIX `get_current_release_branch`
  git-flow bugfix publish $BUGFIX
fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  git checkout bugfix/$BUGFIX

  export GIT_MERGE_AUTOEDIT=no
  git-flow bugfix finish -p $BUGFIX
  
  git checkout `get_current_release_branch`
fi