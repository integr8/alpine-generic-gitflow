FROM alpine:3.8
LABEL maintainer="Fábio Luciano"

RUN printf "password\npassword" | adduser gitflow \
  && apk add --no-cache --virtual .buildeps gcc libxml2-dev libxslt-dev libc-dev python-dev \
  && apk --no-cache add git bash jq py2-pip libxml2 util-linux openssh-client gawk curl \
  && pip install --upgrade pip && pip install --no-cache-dir --upgrade --user yq \
  && wget --no-check-certificate -q  https://raw.githubusercontent.com/petervanderdoes/gitflow-avh/develop/contrib/gitflow-installer.sh -O- | bash -s -- install stable \
  && mkdir -p ~/.ssh && printf "Host *\n  StrictHostKeyChecking no" >> ~/.ssh/config \ 
  && sed -i 's/readlink \-e/ readlink -f/' /usr/local/bin/git-flow \
  && mkdir -p /home/gitflow/.ssh/ && printf "Host *\n\tStrictHostKeyChecking no" > /home/gitflow/.ssh/config \
  && mkdir -p /opt/source -m 0777 && apk del .buildeps

COPY files/script/*.sh /usr/local/bin/ctn/
COPY files/script/wrapper/ /usr/local/bin/ctn/wrapper
COPY files/script/strategy/ /usr/local/bin/ctn/strategy
COPY files/gitconfig /etc

RUN chmod +x /usr/local/bin/ctn/entrypoint.sh

USER 1000


ENTRYPOINT [ "/usr/local/bin/ctn/entrypoint.sh" ]