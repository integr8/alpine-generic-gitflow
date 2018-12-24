#!/bin/bash

find_latest_semver() {
  pattern="^$PREFIX([0-9]+\.[0-9]+\.[0-9]+)\$"
  versions=$(for tag in $(git tag); do
    [[ "$tag" =~ $pattern ]] && echo "${BASH_REMATCH[1]}"
  done)
  if [ -z "$versions" ];then
    echo 0.0.0
  else
    echo "$versions" | tr '.' ' ' | sort -nr -k 1 -k 2 -k 3 | tr ' ' '.' | head -1
  fi
}

increment_ver() {
  find_latest_semver | awk -F. -v major="$1" -v minor="$2" -v patch="$3" \
      '{
         if(major == 1)
            printf("%d.%d.%d", $1+major, 0 , 0)
         else if(minor == 1)
            printf("%d.%d.%d", $1+major, $2+minor , 0)
         else if(patch == 1)
            printf("%d.%d.%d", $1+major, $2+minor , $3+patch)
      }'
}

bump() {
  next_ver="${PREFIX}$(increment_ver "$1" "$2" "$3")"
  latest_ver="${PREFIX}$(find_latest_semver)"
  latest_commit=$(git rev-parse "${latest_ver}" 2>/dev/null )
  head_commit=$(git rev-parse HEAD)

  if [ "$RETURN" ]; then
    echo "$next_ver"
    exit 0
  fi

  if [ "$latest_commit" = "$head_commit" ]; then
      echo "refusing to tag; $latest_ver already tagged for HEAD ($head_commit)"
  else
      echo "tagging $next_ver $head_commit"
      git tag "$next_ver" $head_commit
  fi
}

usage() {
  echo "Usage: bump [-p prefix] {major|minor|patch} | -l"
  echo "Bumps the semantic version field by one for a git-project."
  echo
  echo "Options:"
  echo "  -l  list the latest tagged version instead of bumping."
  echo "  -p  prefix [to be] used for the semver tags."
  echo "  -r  return next"
  exit 1
}

while getopts :p:l:r opt; do
  case $opt in
    p) PREFIX="$OPTARG";;
    r) RETURN=1;;
    l) LIST=1;;
    \?) usage;;
    :) echo "option -$OPTARG requires an argument"; exit 1;;
  esac
done
shift $((OPTIND-1))

if [ ! -z "$LIST" ];then
  find_latest_semver
  exit 0
fi

case $1 in
  major) bump 1 0 0;;
  minor) bump 0 1 0;;
  patch) bump 0 0 1;;
  *) usage
esac