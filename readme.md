# Gitflow Helper

[![Build Status](https://travis-ci.org/integr8/alpine-gitflow-helper.svg?branch=development)](https://travis-ci.org/integr8/alpine-gitflow-helper)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fintegr8%2Falpine-gitflow-helper.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fintegr8%2Falpine-gitflow-helper?ref=badge_shield)

Documentação: https://integr8.github.io/alpine-gitflow-helper/


docker run --rm -ti -e 'SOURCE_METHOD=VOLUME' -e 'PROJECT_TYPE=PHP' -e 'BUMP_MODE=CANDIDATE' -e 'GITLAB_TOKEN=' -e 'GITLAB_URL=https://gitlab.com' -v $(pwd):/opt/source -v /home/diego/.ssh/id_rsa:/root/.ssh/id_rsa alpine-gitflow-helper bugfix start teste



## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fintegr8%2Falpine-gitflow-helper.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fintegr8%2Falpine-gitflow-helper?ref=badge_large)