# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taope/version'

Gem::Specification.new do |gem|
  gem.name          = "taope"
  gem.version       = Taope::VERSION
  gem.authors       = ["jiawulu"]
  gem.email         = ["jiawu.lu@gmail.com"]
  gem.description   = "tao pe system util"
  gem.summary       = ""
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  #gem.add_dependency('starfish','>= 1.0')
end