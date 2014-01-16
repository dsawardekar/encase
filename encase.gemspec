# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encase/version'

Gem::Specification.new do |spec|
  spec.name          = "encase"
  spec.version       = Encase::VERSION
  spec.authors       = ["Darshan Sawardekar"]
  spec.email         = ["darshan@sawardekar.org"]
  spec.summary       = %q{Lightweight IOC Container for ruby.}
  spec.description   = %q{Encase is a library for using dependency injection within ruby applications. It provides a lightweight IOC Container that manages dependencies between your classes. It was written to assist with wiring of domain objects outside Rails applications to enable faster test suites.}
  spec.homepage      = "https://github.com/dsawardekar/encase"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
end
