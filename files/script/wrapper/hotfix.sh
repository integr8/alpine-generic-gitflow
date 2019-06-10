#!/bin/bash
SUBCOMMAND=$2
HOTFIX=$3

if [[ "${SUBCOMMAND}" == 'start' ]]; then
  BUMP_MODE="PATCH"
  . $BINARY_PATH/version_bumper.sh

  git-flow hotfix start $next_version
  . $BINARY_PATH/strategy.sh
  git add -A
  git commit -m 'Atualizando arquivo de versão do projeto para a versão '$next_version
  git-flow hotfix publish $next_version
fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  git checkout hotfix/`get_current_patch_version`
  export GIT_MERGE_AUTOEDIT=no
  git-flow hotfix finish -p -m "Closing version"
  unset GIT_MERGE_AUTOEDIT
fi
