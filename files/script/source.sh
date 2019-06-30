#!/bin/bash

if [ "$SOURCE_METHOD" == 'GIT' ]; then
  : ${GIT_URL?   "Por favor, informe o endereço do repositório do git" }

  git config --global http.sslVerify "false"

  if [[ "$GIT_URL" =~ ^http ]]; then
    : ${GIT_USER?  "Por favor, informe o usuário do git" }
    : ${GIT_PASS?  "Por favor, informe a senha do usuario do git" }

    git config --global credential.username ${GIT_USER}
    git config --global credential.helper '!f() { echo "password='${GIT_PASS}'"; }; f'

  elif [[ "${GIT_URL}" =~ ^git@ ]]; then 
    [[ -f /home/${CONTAINER_USERNAME}/.ssh/id_rsa ]] && echo 'Para usar esse tipo de url, crie um volume com a chave!'
    chmod 400 /home/${CONTAINER_USERNAME}/.ssh/id_rsa
  fi

  rm $SOURCE_PATH/* -rf
  ssh-keyscan -H `get_uri_info $GIT_URL host` > /home/${CONTAINER_USERNAME}/.ssh/known_hosts

  git clone --progress --verbose ${GIT_URL} $SOURCE_PATH

  for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master`; do
    git branch --track ${branch#remotes/origin/} $branch &> /dev/null
  done

  git fetch --all
  git branch master > /dev/null

elif [ "$SOURCE_METHOD" == 'VOLUME' ]; then
  if [ ! -d "$SOURCE_PATH" ]; then
      echo 'Foi informado que o código fonte seria provido por um volume, mas o diretório não existe'
  fi
  
  chmod 400 /home/${CONTAINER_USERNAME}/.ssh/id_rsa
  git remote get-url origin
  ssh-keyscan -H `get_uri_info $GIT_URL host` >> /home/${CONTAINER_USERNAME}/.ssh/known_hosts
fi
