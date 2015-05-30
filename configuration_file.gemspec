# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'configuration_file/version'

Gem::Specification.new do |spec|
  spec.name          = "configuration_file"
  spec.version       = ConfigurationFile::VERSION
  spec.authors       = ["Nils Landt"]
  spec.email         = ["nils@promisedlandt.de"]
  spec.description   = %q{Simple gem to load a configuration file, like a Vagrantfile}
  spec.summary       = spec.description
  spec.homepage      = "https://www.github.com/promisedlandt/configuration_file"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "byebug", "~> 5"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "guard", "~> 1.8"
  spec.add_development_dependency "rubocop", "~> 0.14"
  spec.add_development_dependency "mocha", "~> 0.13"
  spec.add_development_dependency "guard-minitest", "~> 1"
  spec.add_development_dependency "yard", "~> 0.8"
end
