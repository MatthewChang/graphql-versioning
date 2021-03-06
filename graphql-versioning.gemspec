$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'graphql/versioning/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'graphql-versioning'
  s.version     = GraphQL::Authorization::VERSION
  s.authors     = ['Matthew Chang']
  s.email       = ['matthew@callnine.com']
  s.homepage    = 'https://github.com/Call9/graphql-versioning'
  s.summary     = 'An authorization framework for graphql-ruby'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_runtime_dependency 'graphql', '~> 1.6', '>= 1.6.3'
  s.add_development_dependency 'rspec', '~> 3'
end
