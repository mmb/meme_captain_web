FROM ruby:2.1
MAINTAINER matthewm@boedicker.org

RUN ln -s \
  /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/Magick-config \
  /usr/local/bin

COPY . /usr/src/app

WORKDIR /usr/src/app

RUN ["bundle"]

RUN ["bundle", "exec", "rake", "assets:precompile"]

CMD ["bundle", "exec", "rails", "server"]
