FROM mm62/meme-captain-web-deps
MAINTAINER matthewm@boedicker.org

COPY . /app

WORKDIR /app

RUN /usr/local/sbin/varnishd -C -f docker/default.vcl

ENV RAILS_SERVE_STATIC_FILES true

RUN export LDFLAGS=-lMagickWand-6.Q16 \
  && gem update --system \
  && bundle install \
     --without=development test \
     --jobs=4 \
  && bundle exec rake \
    assets:precompile \
    RAILS_ENV=production

ENV MEMCACHE_SERVERS 127.0.0.1

CMD ["/usr/bin/runsvdir", "-P", "/app/docker/runit"]

EXPOSE 6081
