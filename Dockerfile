FROM alpine:3.10

ENV HUGO_VERSION=0.56.2

# download hugo
RUN \
  adduser -h /site -s /sbin/nologin -u 1000 -D hugo && \
  apk add --no-cache dumb-init wget bash git openssh bind-tools curl \
  && wget --no-check-certificate https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && tar zxvf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && mv hugo /bin/hugo \
  && chmod +x /bin/hugo

# create empty site
RUN mkdir -p /site \
    && /bin/hugo new site /site

# clone theme
RUN git init
RUN git submodule add https://github.com/dzello/reveal-hugo.git /site/themes/reveal-hugo

# fave number to rebuild from there
ENV REVISION 1

# change owner
RUN chown -R 1000 /site 

# user, workdir, port
USER    hugo
WORKDIR /site
EXPOSE  1313

# css
RUN mkdir -p static/reveal-hugo/themes
COPY robot-lung.css static/reveal-hugo/themes

# partials
RUN mkdir -p layouts/partials/reveal-hugo
COPY head.html layouts/partials/reveal-hugo
COPY body.html layouts/partials/reveal-hugo
COPY end.html layouts/partials/reveal-hugo

# config
COPY config.toml .

# setup a welcome page
COPY oui-logo.png content/
COPY _index.md content/

ENTRYPOINT ["/usr/bin/dumb-init", "--", "hugo"]