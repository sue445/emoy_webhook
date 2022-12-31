FROM ruby:3.2

ENV RACK_ENV=production

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN bundle config set --local jobs 2 && \
    bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

COPY . .

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
