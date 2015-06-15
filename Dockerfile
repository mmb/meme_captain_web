FROM ruby:2.2
MAINTAINER matthewm@boedicker.org

RUN ["apt-get", "update"]
RUN ["apt-get", "install", "--assume-yes", \
  "memcached", \
  "monit", \
  "runit", \
  "varnish" \
  ]

COPY . /app

WORKDIR /app

RUN ["bundle", "install", "--jobs=4"]

RUN ["bundle", "exec", "rake", "build_metadata[build_metadata.json]"]

RUN ["bundle", "exec", "rake", "assets:precompile", "RAILS_ENV=production"]

COPY docker/default.vcl /etc/varnish/default.vcl
COPY docker/varnish_defaults /etc/default/varnish

ENV MEMCACHE_SERVERS 127.0.0.1

CMD ["/usr/bin/runsvdir", "-P", "/app/docker/runit"]

EXPOSE 6081
