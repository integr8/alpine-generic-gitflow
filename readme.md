# Gitflow Helper

[![Build Status](https://travis-ci.org/integr8/alpine-gitflow-helper.svg?branch=development)](https://travis-ci.org/integr8/alpine-gitflow-helper)

Documentação: https://integr8.github.io/alpine-gitflow-helper/


docker run --rm -ti -e 'SOURCE_METHOD=VOLUME' -e 'PROJECT_TYPE=PHP' -e 'BUMP_MODE=CANDIDATE' -e 'GITLAB_TOKEN=' -e 'GITLAB_URL=https://gitlab.com' -v $(pwd):/opt/source -v /home/diego/.ssh/id_rsa:/root/.ssh/id_rsa alpine-gitflow-helper bugfix start teste
