#!/bin/bash
SUBCOMMAND=$2

: ${BUMP_MODE? 'É necessário informar um tipo de bump: MAJOR, MINOR ou CANDIDATE'}

if [[ "${SUBCOMMAND}" == 'start' ]]; then

  [[ $BUMP_MODE != "MINOR" ]] && [[ $BUMP_MODE != "MAJOR" ]] &&  echo 'MINOR ou MAJOR';

  git-flow release start $next_version
  . $BINARY_PATH/strategy.sh

  git add -A
  git commit -m 'Atualizando arquivo de versão do projeto para a versão '$next_version
  
  git-flow release publish

fi

if [[ "${SUBCOMMAND}" == 'finish' ]]; then
  TAG_TOBE_CLOSE=`get_current_release_version`
  LATEST_VERSION=`get_latest_tag`

  PATTERN_RELEASE_CANDIDATE="^(`get_current_release_version`-rc\.[0-9]{1,})\$"
  for tag in $(git tag); do
    if [[ "$tag" =~ $PATTERN_RELEASE_CANDIDATE ]]; then
      git tag -d "${BASH_REMATCH[1]}"
      git push --delete origin "${BASH_REMATCH[1]}"
    fi
  done

  export GIT_MERGE_AUTOEDIT=no
  git-flow release finish -p -m "Closing version"
  unset GIT_MERGE_AUTOEDIT

  if [[ ! -z "$GITLAB_TOKEN" ]]; then
    release_note=$(get_release_message $LATEST_VERSION)
    create_release_note "$TAG_TOBE_CLOSE" "$release_note"
  fi
fi

if [[ "${SUBCOMMAND}" == 'candidate' ]]; then
  BUMP_MODE='CANDIDATE'
  . $BINARY_PATH/version_bumper.sh
  
  release_candidate=$next_version
  latest_release_candidate=`get_latest_release_candidate_tag`

  git checkout -b release-candidate/$release_candidate
  . $BINARY_PATH/strategy.sh

  git add -A
  git commit -m 'Atualizando arquivo de versão do projeto para a versão '$next_version

  git tag $release_candidate
  git push origin $release_candidate
  
  git checkout `get_current_release_branch`
  git branch -D release-candidate/$release_candidate

  if [[ ! -z "$GITLAB_TOKEN" ]]; then
    release_note=$(get_release_message $latest_release_candidate)
    create_release_note $release_candidate "$release_note"
  fi
fi