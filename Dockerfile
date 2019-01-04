FROM alpine:3.8
LABEL maintainer="Fábio Luciano"

RUN apk add --no-cache --virtual .buildeps gcc libxml2-dev libxslt-dev libc-dev python-dev \
  && apk --no-cache add git bash jq py2-pip libxml2  \
  && pip install --upgrade pip && pip install --no-cache-dir --upgrade --user xq \
  && wget https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh -O- | INSTALL_PREFIX=/usr/local/bin/ bash \
  && apk del .buildeps

COPY files/script/*.sh /usr/local/bin/
COPY files/gitconfig /etc/

RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /opt

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
