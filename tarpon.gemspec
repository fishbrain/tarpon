lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tarpon/version"

Gem::Specification.new do |spec|
  spec.name          = "tarpon"
  spec.version       = Tarpon::VERSION
  spec.authors       = ["Igor Belo"]
  spec.email         = ["igor.belo@fishbrain.com"]

  spec.description   = %q{A ruby interface to RevenueCat REST API}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/fishbrain/tarpon"
  spec.license       = "MIT"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fishbrain/tarpon"
  spec.metadata["changelog_uri"] = "https://github.com/fishbrain/tarpon/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "http", "~> 4.3"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "factory_bot", "~> 5.1"
end
