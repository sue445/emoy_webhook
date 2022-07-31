# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.1.2"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "puma", require: false
gem "redis-objects"
gem "rollbar"
gem "sinatra", ">= 2.2.0"
gem "sinatra-contrib", ">= 2.2.0"
gem "slack-notifier", ">= 2.4.0"

group :development do
  gem "dotenv", require: "dotenv/load"
  gem "foreman", require: false
  gem "pry-byebug", group: :test
  gem "rake", require: false
end

group :test do
  gem "coveralls", require: false
  gem "rack-test"
  gem "rspec"
  gem "simplecov", require: false
end
