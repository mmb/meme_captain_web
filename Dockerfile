FROM debian:jessie
MAINTAINER matthewm@boedicker.org

WORKDIR /tmp

# packages
RUN apt-get update && \
  apt-get install --assume-yes \
    build-essential \
    curl \
    memcached \
    runit

# imagemagick
RUN apt-get install --assume-yes \
    inkscape \
    libbz2-dev \
    libfftw3-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libjbig-dev \
    libjpeg62-turbo-dev \
    liblzma-dev \
    libpango1.0-dev \
    libpng12-dev \
    libtiff5-dev \
    libwebp-dev \
    libxml2-dev \
    pkg-config \
    zlib1g-dev \
  && curl http://imagemagick.org/download/ImageMagick-6.9.2-5.tar.bz2 \
    | tar jx \
  && cd ImageMagick-6.9.2-5 \
  && ./configure \
  && make \
  && make install \
  && cd ..

# ruby
RUN apt-get install --assume-yes \
    git \
    libreadline-dev \
    libssl-dev \
  && curl http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.bz2 \
    | tar jx \
  && cd ruby-2.2.3 \
  && ./configure \
    --disable-install-doc \
  && make \
  && make install \
  && echo 'gem: --no-document' >> "$HOME/.gemrc" \
  && gem install bundler \
  && cd ..

# varnish
RUN apt-get install --assume-yes \
    apt-transport-https \
  && curl https://repo.varnish-cache.org/GPG-key.txt \
    | apt-key add - \
  && echo 'deb https://repo.varnish-cache.org/debian/ jessie varnish-4.1' \
    >> /etc/apt/sources.list.d/varnish-cache.list \
  && apt-get update \
  && apt-get install --assume-yes varnish
COPY docker/default.vcl /etc/varnish/default.vcl
COPY docker/varnish_defaults /etc/default/varnish

# monit
RUN apt-get install --assume-yes \
    libpam-dev \
  && curl https://mmonit.com/monit/dist/monit-5.14.tar.gz \
    | tar xz \
  && cd monit-5.14 \
  && ./configure \
  && make \
  && make install \
  && mkdir -p /var/lib/monit/events \
  && cd ..

COPY . /app

WORKDIR /app

RUN apt-get install --assume-yes \
    libpq-dev \
    libsqlite3-dev \
  && export LDFLAGS=-lMagickWand-6.Q16 \
  && bundle install --jobs=4 \
  && bundle exec rake \
    build_metadata[build_metadata.json] \
    assets:precompile RAILS_ENV=production

# cleanup
RUN apt-get clean \
  && rm -rf /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ENV MEMCACHE_SERVERS 127.0.0.1

CMD ["/usr/bin/runsvdir", "-P", "/app/docker/runit"]

EXPOSE 6081
