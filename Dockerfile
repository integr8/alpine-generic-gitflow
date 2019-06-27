FROM alpine:3.8
LABEL maintainer="Fábio Luciano"

ARG CONTAINER_USERNAME=integr8
ENV CONTAINER_USERNAME=${CONTAINER_USERNAME}

COPY files/script/*.sh /usr/local/bin/ctn/
COPY files/script/wrapper/ /usr/local/bin/ctn/wrapper
COPY files/script/strategy/ /usr/local/bin/ctn/strategy
COPY files/gitconfig /etc

RUN printf "password\npassword" | adduser ${CONTAINER_USERNAME} \
  && apk add --no-cache --virtual .buildeps gcc libxml2-dev libxslt-dev libc-dev python-dev \
  && apk --no-cache add git bash jq py2-pip libxml2 util-linux openssh-client gawk curl \
  && pip install --upgrade pip && pip install --no-cache-dir --upgrade yq \
  && wget --no-check-certificate -q  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh -O- | bash -s -- install stable \
  && sed -i 's/readlink \-e/ readlink -f/' /usr/local/bin/git-flow \
  && mkdir -p /opt/source -m 0777 && apk del .buildeps \
  && chmod +x /usr/local/bin/ctn/entrypoint.sh

USER gitflow

RUN mkdir -p /home/${CONTAINER_USERNAME}/.ssh/ && printf "Host *\n  StrictHostKeyChecking no" >> /home/${CONTAINER_USERNAME}/.ssh/config

ENTRYPOINT [ "/usr/local/bin/ctn/entrypoint.sh" ]
