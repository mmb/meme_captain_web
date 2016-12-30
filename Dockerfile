FROM debian:jessie
MAINTAINER matthewm@boedicker.org

WORKDIR /tmp

COPY docker/sources.list /etc/apt/sources.list

# packages
RUN apt-get update \
  && apt-get install --assume-yes \
    build-essential \
    curl \
    memcached \
    runit

# imagemagick
RUN apt-get update \
  && apt-get install --assume-yes \
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
  && curl https://www.imagemagick.org/download/ImageMagick-6.9.6-8.tar.xz \
    | tar xJ \
  && cd $(ls -d ImageMagick-* | head -n 1) \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && rm -rf $(ls -d ImageMagick-* | head -n 1)

# ruby
RUN apt-get update \
  && apt-get install --assume-yes \
    git \
    libreadline-dev \
    libssl-dev \
  && curl https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.0.tar.bz2 \
    | tar xj \
  && cd $(ls -d ruby-* | head -n 1) \
  && ./configure \
    --disable-install-doc \
  && make \
  && make install \
  && echo 'gem: --no-document' >> "$HOME/.gemrc" \
  && gem install bundler \
  && cd .. \
  && rm -rf $(ls -d ruby-* | head -n 1)

# varnish
RUN apt-get update \
  && apt-get install --assume-yes \
    libjemalloc-dev \
    libncurses-dev \
    python-docutils \
  && curl https://repo.varnish-cache.org/source/varnish-5.0.0.tar.gz \
    | tar xz \
  && cd $(ls -d varnish-* | head -n 1) \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && rm -rf $(ls -d varnish-* | head -n 1)

# monit
RUN apt-get update \
  && apt-get install --assume-yes \
    libpam-dev \
    ucspi-tcp \
  && curl https://mmonit.com/monit/dist/monit-5.20.0.tar.gz \
    | tar xz \
  && cd $(ls -d monit-* | head -n 1) \
  && ./configure \
  && make \
  && make install \
  && mkdir -p /var/lib/monit/events \
  && cd .. \
  && rm -rf $(ls -d monit-* | head -n 1)

COPY . /app

WORKDIR /app

RUN /usr/local/sbin/varnishd -C -f docker/default.vcl

ENV RAILS_SERVE_STATIC_FILES true

RUN apt-get update \
  && apt-get install --assume-yes \
    libpq-dev \
    libsqlite3-dev \
  && export LDFLAGS=-lMagickWand-6.Q16 \
  && bundle install \
     --without=development test \
     --jobs=4 \
  && bundle exec rake \
    assets:precompile \
    RAILS_ENV=production

# cleanup
RUN apt-get clean \
  && rm -rf /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ENV MEMCACHE_SERVERS 127.0.0.1

CMD ["/usr/bin/runsvdir", "-P", "/app/docker/runit"]

EXPOSE 6081
