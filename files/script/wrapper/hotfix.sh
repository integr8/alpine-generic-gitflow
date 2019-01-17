#!/bin/bash
SUBCOMMAND=$2
HOTFIX=$3

if [[ "${SUBCOMMAND}" == 'start' ]]; then
  BUMP_MODE="PATCH"
  . $BINARY_PATH/version_bumper.sh

  git-flow bugfix start $next_version
  . $BINARY_PATH/strategy.sh
  git add -A
  git commit -m 'Atualizando arquivo de versão do projeto para a versão '$next_version
  git-flow bugfix publish $next_version
fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  git checkout `get_current_release_branch`
  git merge feature/$FEATURE
  git checkout `get_current_release_branch`
  git branch -D feature/$FEATURE
  git push origin --delete feature/$FEATURE

  export GIT_MERGE_AUTOEDIT=no
  git-flow hotfix finish $HOTFIX -p -m "Closing version"
  unset GIT_MERGE_AUTOEDIT
fi