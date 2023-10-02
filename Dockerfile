ARG RUBY_VERSION=3.2.2

FROM ruby:$RUBY_VERSION-alpine

WORKDIR /app

ENV BUNDLE_PATH=vendor/bundle
ENV BUNDLE_WITHOUT=development:test
ENV BUNDLE_CLEAN=true

# linux-headers required by nio4r
# build-base for native extensions
# git for git repos in the Gemfile
RUN apk add linux-headers build-base git

COPY .ruby-version .
COPY Gemfile* .

RUN bundle install

RUN rm -rf vendor/bundle/ruby/*/cache

COPY . .
