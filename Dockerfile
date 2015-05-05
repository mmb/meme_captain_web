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

RUN ["bundle", "exec", "rake", "assets:precompile"]

COPY docker/default.vcl /etc/varnish/default.vcl

ENV MEMCACHE_SERVERS 127.0.0.1

CMD ["/usr/bin/runsvdir", "-P", "/app/docker/runit"]

EXPOSE 6081
