FROM ruby:3.1.2-alpine3.16
RUN apk update && apk upgrade \
  && apk --no-cache add \
  git \
  build-base \
  bash \
  nodejs \
  yarn \
  libpq-dev \
  && gem install bundler -v 2.3.18

WORKDIR /code
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY package.json yarn.lock ./
RUN yarn install
COPY . ./
RUN bundle exec whenever --update-crontab
