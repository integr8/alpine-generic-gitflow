#!/bin/bash
SUBCOMMAND=$2
FEATURE=$3

if [[ "${SUBCOMMAND}" == 'list' ]]; then
  git-flow feature list
fi

if [[ "${SUBCOMMAND}" == 'start' ]]; then
  git checkout `get_current_release_branch`
  git-flow feature start $FEATURE `get_current_release_branch`
  git-flow feature publish $FEATURE
fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  git checkout `get_current_release_branch`
  git merge feature/$FEATURE
  git branch -D feature/$FEATURE
  git push origin --delete feature/$FEATURE
fi