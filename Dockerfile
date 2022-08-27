FROM ruby:3.1.2

ENV RACK_ENV=production

WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN bundle config set --local jobs 2 && \
    bundle install --without=development test --deployment

COPY . .

CMD ["bundle", "exec", "puma", "-p", "3000"]
