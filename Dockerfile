FROM alpine:3.10

ENV HUGO_VERSION=0.56.2

RUN \
  adduser -h /site -s /sbin/nologin -u 1000 -D hugo && \
  apk add --no-cache dumb-init wget bash git openssh bind-tools curl \
  && wget --no-check-certificate https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && tar zxvf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && mv hugo /bin/hugo \
  && chmod +x /bin/hugo

RUN mkdir -p /site \
    && /bin/hugo new site /site \
    && chown -R hugo /site 

RUN git init
RUN git submodule add https://github.com/dzello/reveal-hugo.git /site/themes/reveal-hugo

RUN mkdir -p static/reveal-hugo/themes
COPY robot-lung.css static/reveal-hugo/themes

USER    hugo
WORKDIR /site
VOLUME  /site
EXPOSE  1313

COPY config.toml .
COPY _index.md content/

ENTRYPOINT ["/usr/bin/dumb-init", "--", "hugo"]