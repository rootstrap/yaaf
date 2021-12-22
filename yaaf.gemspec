# frozen_string_literal: true

require_relative 'lib/yaaf/version'

Gem::Specification.new do |spec|
  spec.name          = 'yaaf'
  spec.version       = YAAF::VERSION
  spec.authors       = ['Juan Manuel Ramallo', 'Santiago Bartesaghi']
  spec.email         = ['juan.ramallo@rootstrap.com']

  spec.summary       = 'Easing the form object pattern in Rails applications.'
  spec.homepage      = 'https://github.com/rootstrap/yaaf'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/rootstrap/yaaf'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/rootstrap/yaaf/issues'
  spec.metadata['changelog_uri'] = 'https://github.com/rootstrap/yaaf/releases'

  spec.files = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 5.2'
  spec.add_dependency 'activerecord', '>= 5.2'

  spec.add_development_dependency 'database_cleaner-active_record', '~> 1.8.0'
  spec.add_development_dependency 'rake', '~> 13.0.1'
  spec.add_development_dependency 'reek', '~> 5.6.0'
  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'rubocop', '~> 0.80.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
  spec.add_development_dependency 'sqlite3', '~> 1.4.2'
end
