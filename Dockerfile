ARG RUBY_VERSION=4.0

FROM ruby:${RUBY_VERSION}-slim AS builder

ENV RACK_ENV=production

WORKDIR /app

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock /app/

RUN bundle config set --local jobs 2 && \
    bundle config set --global frozen 'true' && \
    bundle config set --local without 'development test' && \
    bundle install && \
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

FROM ruby:${RUBY_VERSION}-slim

ENV RACK_ENV=production

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle

COPY . .

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
