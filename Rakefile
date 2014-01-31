require 'rubygems/package_task'

spec = Gem::Specification.load(File.expand_path('../hexp.gemspec', __FILE__))
gem = Gem::PackageTask.new(spec)
gem.define

desc "Push gem to rubygems.org"
task :push => :gem do
  sh "git tag v#{Hexp::VERSION}"
  sh "git push --tags"
  sh "gem push pkg/hexp-#{Hexp::VERSION}.gem"
end
