# -*- encoding: utf-8 -*-
require File.expand_path('../lib/trivial_gem_server/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "trivial_gem_server"
  gem.authors       = ["Fabien Catteau"]
  gem.email         = ["fabien.catteau@mingalar.fr"]
  gem.homepage      = "https://github.com/fcat/trivial_gem_server"
  gem.summary       = %q{Demonstrates a minimal gem server}
  gem.description   = <<desc
  This sinatra-based application illustrates how to build a minimal
  server for your Ruby gems. It is fully compatible with rubygems client.
desc

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = TrivialGemServer::VERSION

  gem.required_rubygems_version = '>= 2.0.0'
  gem.add_runtime_dependency 'sinatra', '~> 1.4.3'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rack-test', '~> 0.6.2'
end
