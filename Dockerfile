FROM ruby:3.3-slim

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libsqlite3-dev \
  libyaml-dev \
  nodejs \
  npm \
  curl \
  git \
  libvips \
  && rm -rf /var/lib/apt/lists/*

RUN gem install rails -v '~> 7.2'

WORKDIR /rails

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
