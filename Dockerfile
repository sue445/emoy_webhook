FROM ruby:3.4-slim

ENV RACK_ENV=production

WORKDIR /app

RUN apt-get update && \
    apt-get install -y gcc ruby-dev make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock /app/

RUN bundle config set --local jobs 2 && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

COPY . .

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
