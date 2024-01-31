# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "connection_pool"
gem "google-cloud-firestore", require: "google/cloud/firestore"
gem "puma", require: false
gem "redis-objects"
gem "sentry-ruby"
gem "sinatra-contrib", ">= 2.2.0"
gem "slack-notifier", ">= 2.4.0"
gem "uri", ">= 0.12.2" # for CVE-2023-36617

# FIXME: Remove this after google-protobuf v3.26 is published
# c.f. https://github.com/protocolbuffers/protobuf/pull/15203
gem "rake", require: false

group :development do
  gem "dotenv", require: "dotenv/load"
  # gem "rake", require: false
end

group :test do
  gem "coveralls_reborn", require: false
  gem "rack-test"
  gem "rspec"
  gem "simplecov", require: false
end
