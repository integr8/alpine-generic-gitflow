#!/bin/bash
 
: ${GITLAB_TOKEN? 'É Necessário informar o token de acesso ao gitlab'}

recover_project_id() {
  remote=`git remote get-url --push origin`
  
  if [[ "$remote" =~ ([a-zA-Z0-9_-]+)\.git ]]; then
    project_name="${BASH_REMATCH[1]}"
    x=`wget --quiet --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://gitlab.com/api/v4/search?scope=projects&search=$project_name" -O-`
    api_remote=`echo $x | jq -r '.[0].ssh_url_to_repo'`
    project_id=`echo $x | jq -r '.[0].id'`
    
    if [[ "$remote" ==  "$api_remote" ]]; then
      echo $project_id
    fi 
  fi
}

create_release_note() {
  tag=$1
  release_note=$(cat $2)
  project_id=`recover_project_id`

  wget -O- --verbose --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" --post-data "{\"tag\":\"$tag\", \"description\":\"$(echo -e "$release_note")\"}" --header=Content-Type:application/json https://gitlab.com/api/v4/projects/$project_id/repository/tags/$tag/release
}