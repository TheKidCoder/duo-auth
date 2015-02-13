# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'duo/auth/version'

Gem::Specification.new do |spec|
  spec.name          = "duo-auth"
  spec.version       = Duo::Auth::VERSION
  spec.authors       = ["Christopher Ostrowski"]
  spec.email         = ["chris@madebyfunction.com"]
  spec.summary       = %q{Sign & Verify 2-factor auth requests using DUO Security.}
  spec.description   = %q{This is a minimal gem that will provide the ability to sign & verify a duo request. Doesn't include any view layer.}
  spec.homepage      = "http://github.com/thekidcoder/duo-auth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
