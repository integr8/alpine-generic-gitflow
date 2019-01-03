FROM alpine:3.8
LABEL maintainer="Fábio Luciano"

ADD files/bump.sh /usr/local/bin/bump
ADD files/entrypoint.sh /usr/local/bin/entrypoint

RUN apk add --no-cache --virtual .buildeps gcc libxml2-dev libxslt-dev libc-dev python-dev \
  && apk --no-cache add git bash jq py2-pip libxml2  \
  && pip install --upgrade pip && pip install --no-cache-dir --upgrade --user xq \
  && apk del .buildeps 

WORKDIR /opt

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
