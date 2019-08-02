FROM alpine:3.10

ENV HUGO_VERSION=0.56.3
ENV REVEAL_HUGO_VERSION=3788609d238d3a72d0446e936838e80f210d8c2b

# download hugo (libc6-compat needed for hugo extended)
RUN \
  adduser -h /site -s /sbin/nologin -u 1000 -D hugo && \
  apk add --no-cache wget bash openssh bind-tools libc6-compat \
  && wget --no-check-certificate https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && tar zxvf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
  && mv hugo /bin/hugo \
  && chmod +x /bin/hugo

RUN ls -al /bin/hugo
RUN /bin/hugo version

# create empty site
RUN mkdir -p /site \
    && /bin/hugo new site /site

# download theme
RUN \
  mkdir -p /site/themes/reveal-hugo \
  && wget --no-check-certificate -O reveal-hugo.tar.gz https://github.com/dzello/reveal-hugo/archive/${REVEAL_HUGO_VERSION}.tar.gz \
  && tar -C /site/themes/reveal-hugo -zxvf reveal-hugo.tar.gz --strip 1 \
  && rm reveal-hugo.tar.gz

# change owner
RUN chown -R 1000 /site 

# user, workdir, port
USER    hugo
WORKDIR /site
EXPOSE  1313

# css
RUN mkdir -p assets
COPY custom-theme.scss assets

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

# favicon
COPY favicon.ico static/

# serve site by default
ENV HUGO_BASE_URL http://localhost:1313
CMD hugo serve -b ${HUGO_BASE_URL} --bind=0.0.0.0 -D

#CMD sleep 36000