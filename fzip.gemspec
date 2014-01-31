require File.expand_path('../lib/fzip/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'fzip'
  gem.version     = '0.1.0'
  gem.authors     = [ 'Arne Brasseur' ]
  gem.email       = [ 'arne@arnebrasseur.net' ]
  gem.description = 'Functional zipper class'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/plexus/fzip'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md]

  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rspec', '~> 2.14'
end
