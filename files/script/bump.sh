#!/bin/bash
set -e

: ${CANDIDATE_PREFIX:='rc'}
: ${TAG_PREFIX:=''}
: ${BUMP_MODE:='candidate'}

PATTERN="^${TAG_PREFIX}([0-9]{1,}\.[0-9]{1,}\.[0-9]{1,})\$"

get_latest_tag() {
  TAGS=$(for tag in $(git tag); do
    [[ "$tag" =~ $PATTERN ]] && echo "${BASH_REMATCH[0]}"
  done)
  [[ ! -z "$TAGS" ]] &&  echo "$TAGS" | tr '.' ' ' | sort -nr -k1 -k2 -k3 | tr ' ' '.' | head -1
}

get_latest_release_candidate_tag() {
  PATTERN="^${TAG_PREFIX}([0-9]{1,}\.[0-9]{1,}\.[0-9]{1,}\-${CANDIDATE_PREFIX}.[0-9]{1,})\$"
  echo $(get_latest_tag)
}

get_release_candidate() {
  current_release_version=$(git symbolic-ref HEAD  | sed -e 's/.*\///')
  last_release_candidate_tag=$(get_latest_release_candidate_tag)

  if [[ ! -z "$last_release_candidate_tag"  ]]; then
    echo $last_release_candidate_tag | awk -v mode="$BUMP_MODE" 'match($0, /'${CANDIDATE_PREFIX}'\.([0-9])/, matches) {   
      printf("%s%d", "'$current_release_version'-rc.", matches[1]+1 )  
    }'
  # else
  #   echo "${current_release_version}-rc.1"
  fi
}

increment_tag_version() {
  echo $( get_latest_tag | awk -v mode="$BUMP_MODE" 'match($0, /([0-9])\.([0-9])\.([0-9])/, matches) {   
    if(mode == "major")
      printf("%d.%d.%d", matches[1]+1, 0, 0)
    else if(mode == "minor")
      printf("%d.%d.%d",  matches[1], matches[2]+1, 0)
    else if(mode == "patch")
      printf("%d.%d.%d", matches[1], matches[2], matches[3]+1)
   }')
}

bump() {
  if [[ "${BUMP_MODE}" != "candidate" ]]; then
    next_version=$(get_latest_tag)
  else
    next_version=$(get_latest_release_candidate_tag)
  fi

  echo $next_version
}