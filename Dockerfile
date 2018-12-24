FROM alpine:3.8
LABEL maintainer="Fábio Luciano"

ADD files/bump.sh /usr/local/bin/bump
ADD files/entrypoint.sh /usr/local/bin/entrypoint

RUN apk --no-cache add git bash jq \
  && chmod +x /usr/local/bin/*

WORKDIR /opt

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
