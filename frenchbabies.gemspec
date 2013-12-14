# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'frenchbabies/version'

Gem::Specification.new do |spec|
  spec.name          = "frenchbabies"
  spec.version       = FrenchBabies::VERSION
  spec.authors       = ["Kevin Gilpin"]
  spec.email         = ["kgilpin@gmail.com"]
  spec.description   = %q{FrenchBabies blog engine}
  spec.summary       = %q{FrenchBabies blog engine}
  spec.homepage      = "http://frenchbabies.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "mail"
  spec.add_dependency "configliere"
  spec.add_dependency "google-api-client"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
end
