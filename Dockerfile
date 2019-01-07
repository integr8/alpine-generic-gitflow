FROM alpine:3.8
LABEL maintainer="Fábio Luciano"

RUN apk add --no-cache --virtual .buildeps gcc libxml2-dev libxslt-dev libc-dev python-dev openssh-client \
  && apk --no-cache add git bash jq py2-pip libxml2 util-linux \
  && pip install --upgrade pip && pip install --no-cache-dir --upgrade --user yq \
  && wget --no-check-certificate -q  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh -O- | bash -s -- install stable \
  && mkdir -p ~/.ssh && printf "Host *\n  StrictHostKeyChecking no" >> ~/.ssh/config \ 
  && sed -i 's/readlink \-e/ readlink -f/' /usr/local/bin/git-flow \
  && apk del .buildeps

COPY files/script/*.sh /usr/local/bin/ctn/
COPY files/script/wrapper/ /usr/local/bin/ctn/wrapper
COPY files/script/strategy/ /usr/local/bin/ctn/strategy
COPY files/gitconfig /etc/

RUN chmod +x /usr/local/bin/ctn/entrypoint.sh

# VOLUME /opt/source
WORKDIR /opt/source

ENTRYPOINT [ "/usr/local/bin/ctn/entrypoint.sh" ]
