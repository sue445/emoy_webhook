require "rollbar/rake_tasks"

task :environment do
  require "rollbar"
  require "json"
  Rollbar.configure do |config|
    config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
  end
end
