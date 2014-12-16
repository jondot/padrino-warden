# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'padrino/warden/version'

Gem::Specification.new do |spec|
  spec.name          = "padrino-warden"
  spec.version       = Padrino::Warden::VERSION
  spec.authors       = ["Dotan Nahum", "Michał Zając"]
  spec.email         = ["dotan@paracode.com", "padrino-warden@quintasan.pl"]
  spec.description   = %q{basic helpers and authentication methods for using warden with padrino also providing some hooks into Rack::Flash}
  spec.summary       = %q{authentication system for using warden with Padrino, adopted from sinatra_warden}
  spec.homepage      = "https://github.com/jondot/padrino-warden"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'warden', '>= 0.10.3'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
