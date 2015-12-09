lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'haiku_grades/version'

Gem::Specification.new do |spec|
  spec.name          = "haiku_grades"
  spec.version       = HaikuGrades::VERSION
  spec.authors       = ["Sam"]
  spec.email         = ["samf@haikulearning.com"]
  spec.summary       = %q{Pulls grades and exports them from a teacher within a Haiku Learning domain.}
  spec.description   = %q{Pulls grades and exports them from a teacher within a Haiku Learning domain.}
  spec.homepage      = "http://rubygems.org/gems/haiku_grades"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency 'rubocop'
  spec.add_dependency 'hapi-client' # , git: 'git@github.com:haikulearning/hapi-client.git'
  spec.add_dependency 'highline'
end