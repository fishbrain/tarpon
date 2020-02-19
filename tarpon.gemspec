# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tarpon/version'

Gem::Specification.new do |spec|
  spec.name          = 'tarpon'
  spec.version       = Tarpon::VERSION
  spec.authors       = ['Igor Belo']
  spec.email         = ['igor.belo@fishbrain.com']

  spec.description   = 'A ruby interface to RevenueCat REST API'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/fishbrain/tarpon'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/fishbrain/tarpon'
  spec.metadata['changelog_uri'] = 'https://github.com/fishbrain/tarpon/CHANGELOG.md'

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'http', '~> 4.3'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'factory_bot', '~> 5.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.80'
  spec.add_development_dependency 'webmock', '~> 3.8'
end
