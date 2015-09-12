FROM ruby:2.2
MAINTAINER matthewm@boedicker.org

RUN apt-get update && apt-get install --assume-yes \
  apt-transport-https \
  memcached \
  monit \
  runit

RUN curl https://repo.varnish-cache.org/GPG-key.txt | apt-key add -
RUN echo 'deb https://repo.varnish-cache.org/debian/ jessie varnish-4.0' >> /etc/apt/sources.list.d/varnish-cache.list
RUN apt-get update && apt-get install --assume-yes varnish

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
