#!/bin/bash
SUBCOMMAND=$2
FEATURE=$3

if [[ "${SUBCOMMAND}" == 'start' ]]; then
  git-flow feature start $FEATURE `get_current_release_branch`
  git-flow feature publish $FEATURE
fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  git checkout `get_current_release_branch`
  git merge feature/$FEATURE
  git checkout `get_current_release_branch`
  git branch -D feature/$FEATURE
  git push
fi