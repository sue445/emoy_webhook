require "rollbar/rake_tasks"

task :environment do
  require "rollbar"
  require "json"
  Rollbar.configure do |config|
    config.access_token = ENV["ROLLBAR_ACCESS_TOKEN"]
  end
end

desc "Create tag and push"
task :release do
  version = File.read("VERSION").strip
  sh "git tag -a #{version} -m 'Release #{version}'"
  sh "git push --tags"
  sh "git push origin main"
end
