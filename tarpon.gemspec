# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tarpon/version'

Gem::Specification.new do |spec|
  spec.name          = 'tarpon'
  spec.version       = Tarpon::VERSION
  spec.authors       = ['Igor Belo']
  spec.email         = ['igor.belo@fishbrain.com']

  spec.description   = 'A Ruby interface to RevenueCat REST API'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/fishbrain/tarpon'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/fishbrain/tarpon.git'
  spec.metadata['changelog_uri'] = 'https://github.com/fishbrain/tarpon/blob/master/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'http', '~> 4.4'

  # last release before version 7 which requires Ruby 2.7. factory_bot needs activesupport and will go for v7 if no other is provided.
  spec.add_development_dependency 'activesupport', '6.1.7'
  spec.add_development_dependency 'factory_bot', '~> 6.2'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'rubocop', '~> 1.29'
  spec.add_development_dependency 'webmock', '~> 3.14'
end
