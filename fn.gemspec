# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'fn/version'

Gem::Specification.new do |spec|
  spec.name          = "fn"
  spec.version       = Fn::VERSION
  spec.authors       = ["Arne Brasseur"]
  spec.email         = ["arne@arnebrasseur.net"]
  spec.license       = "MPL"

  spec.summary       = %q{Better function objects.}
  spec.description   = %q{Function objects that allow functional composition.}
  spec.homepage      = "https://github.com/plexus/fn"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #spec.bindir        = "bin"
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
