#!/bin/bash

recover_gitlab_address() {
  [[ "$GIT_URL" =~ (https?:\/\/|git@)([^/:]*) ]] && export GITLAB_URL="${BASH_REMATCH[2]}"
}

recover_project_id() {
  remote=`git remote get-url --push origin`

  if [[ "$remote" =~ ([a-zA-Z0-9_-]+)\.git ]]; then
    project_name="${BASH_REMATCH[1]}"
    project_response=`wget --quiet --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "http://${GITLAB_URL}/api/v4/search?scope=projects&search=$project_name" -O-`
    api_remote=`echo $project_response | jq -r '.[0].ssh_url_to_repo'`
    project_id=`echo $project_response | jq -r '.[0].id'`

    if [[ "$remote" ==  "$api_remote" ]]; then
      echo $project_id
    fi
  fi
}

create_release_note_json() {
  tag=$1
  message=$(echo "$2")
  json="{\"tag\":\"${tag}\", \"description\":\"${message}\"}"

  echo "$json"
}

create_release_note() {
  : ${GITLAB_TOKEN? 'É Necessário informar o token de acesso ao gitlab' }
  `recover_gitlab_address`

  project_id=`recover_project_id`
  message=$(create_release_note_json "$1" "$2")

  curl -X POST -q -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" -H "Content-Type: application/json" -d "$message" http://${GITLAB_URL}/api/v4/projects/$project_id/repository/tags/$1/release
}

protect_release_branch() {
  project_id=`recover_project_id`

  curl -v -X PUT -H "PRIVATE-TOKEN: ${GITLAB_TOKEN}" http://${GITLAB_URL}/api/v4/projects/$project_id/protected_branches?name=`get_current_release_branch`&push_access_level=30&merge_access_level=30&unprotect_access_level=40

}