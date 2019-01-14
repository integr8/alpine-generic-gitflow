#!/bin/bash
SUBCOMMAND=$2

: ${BUMP_MODE? 'É necessário informar um tipo de bump: MAJOR, MINOR ou CANDIDATE'}

if [[ "${SUBCOMMAND}" == 'start' ]]; then
  git-flow release start $next_version
  . $BINARY_PATH/strategy.sh

  git add -A
  git commit -m 'Atualizando arquivo de de versão do projeto para a versão '$next_version
  
  git-flow release publish
fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  last_tag=`get_latest_tag`

  release_note_message="Versão `get_current_release_version`\n\n"

  while read -r ; do
    release_note_message="$release_note_message $REPLY\n"; 
  done < <(git log --pretty='format:[%h] %s' $last_tag..HEAD)

  echo -e $release_note_message > /tmp/release-`get_current_release_version`

  PATTERN_RELEASE_CANDIDATE="^(`get_current_release_version`-rc\.[0-9]{1,})\$"
  for tag in $(git tag); do
    if [[ "$tag" =~ $PATTERN_RELEASE_CANDIDATE ]]; then
      git tag -d "${BASH_REMATCH[1]}"
      git push --delete origin "${BASH_REMATCH[1]}"
    fi
  done

  export GIT_MERGE_AUTOEDIT=no
  git-flow release finish -p -f /tmp/release-`get_current_release_version`
  unset GIT_MERGE_AUTOEDIT

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