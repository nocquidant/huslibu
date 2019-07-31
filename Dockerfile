FROM alpine:3.10

ENV HUGO_VERSION=0.56.2

RUN \
  adduser -h /site -s /sbin/nologin -u 1000 -D hugo && \
  apk add --no-cache dumb-init wget \
  && wget --no-check-certificate https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && tar zxvf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && mv hugo /bin/hugo \
  && chmod +x /bin/hugo

USER    hugo
WORKDIR /site
VOLUME  /site
EXPOSE  1313

RUN hugo new site .
RUN mkdir -p reveal-hugo/themes

RUN git init
RUN git submodule add git@github.com:dzello/reveal-hugo.git themes/reveal-hugo

COPY config.toml .
COPY robot-lung.css reveal-hugo/themes

ENTRYPOINT ["/usr/bin/dumb-init", "--", "hugo"]