#!/bin/bash
SUBCOMMAND=$2

: ${BUMP_MODE? 'É necessário informar um tipo de bump: MAJOR, MINOR ou CANDIDATE'}

if [[ "${SUBCOMMAND}" == 'start' ]]; then
  git-flow release start $next_version
  . $BINARY_PATH/strategy.sh

  git add -A
  git commit -m 'Atualizando arquivo de versão do projeto para a versão '$next_version
  
  git-flow release publish
fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  RELEASE_NOTE_FILE_PATH=$(get_release_message `get_latest_tag`)

  PATTERN_RELEASE_CANDIDATE="^(`get_current_release_version`-rc\.[0-9]{1,})\$"
  for tag in $(git tag); do
    if [[ "$tag" =~ $PATTERN_RELEASE_CANDIDATE ]]; then
      git tag -d "${BASH_REMATCH[1]}"
      git push --delete origin "${BASH_REMATCH[1]}"
    fi
  done

  export GIT_MERGE_AUTOEDIT=no
  git-flow release finish -p -f $RELEASE_NOTE_FILE_PATH
  unset GIT_MERGE_AUTOEDIT

  create_release_note $(get_latest_tag) $RELEASE_NOTE_FILE_PATH
fi

if [[ "${SUBCOMMAND}" == 'candidate' ]]; then
  release_candidate=$next_version

  git checkout -b release-candidate/$release_candidate
  . $BINARY_PATH/strategy.sh

  git add -A
  git commit -m 'Updating POMs'

  git tag $release_candidate
  git push origin $release_candidate
  
  git checkout `get_current_release_branch`
  git branch -D release-candidate/$release_candidate
fi