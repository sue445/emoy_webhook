desc "Create tag and push"
task :release do
  version = File.read("VERSION").strip
  sh "git tag -a #{version} -m 'Release #{version}'"
  sh "git push --tags"
  sh "git push origin main"
end
