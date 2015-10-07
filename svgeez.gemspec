# -*- encoding: utf-8 -*-
require File.expand_path('../lib/svgeez/version', __FILE__)

spec = Gem::Specification.new do |gem|
  gem.name = 'svgeez'
  gem.version = SVGeez::VERSION
  gem.summary = "SVG reader, ObjC outputter"
  gem.description = "This gem allows you to convert SVGs to something parsable and readable at compile time for iOS projects."
  gem.has_rdoc = false
  gem.author = "Joshua May"
  gem.email = "josh@notjosh.com"
  gem.homepage = "http://github.com/notjosh/svgeez"
  gem.license = 'MIT'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "svgeez"
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>= 1.9.3'

  # gem.add_runtime_dependency "prawn-svg", :branch => "master"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rake", "~> 10.1"
end
