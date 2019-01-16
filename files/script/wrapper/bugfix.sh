#!/bin/bash
SUBCOMMAND=$2
BUGFIX=$3

if [[ "${SUBCOMMAND}" == 'start' ]]; then
  git-flow bugfix start $BUGFIX `get_current_release_branch`
  git-flow bugfix publish $BUGFIX
fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  git-flow bugfix finish $BUGFIX
fi