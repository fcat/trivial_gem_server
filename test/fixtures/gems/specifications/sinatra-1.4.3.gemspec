Gem::Specification.new do |spec|
  spec.name = "sinatra"
  spec.version = "1.4.3"
  spec.platform = "ruby"
  spec.date = "2013-06-07"
  spec.summary = "Classy web-development dressed in a DSL"
  spec.description = "Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort."
  spec.authors = ["Blake Mizerany", "Ryan Tomayko", "Simon Rozet", "Konstantin Haase"]
  spec.email = "sinatrarb@googlegroups.com"
  spec.homepage = "http://www.sinatrarb.com/"
  spec.add_dependency "rack", "~> 1.4"
  spec.add_dependency "tilt", ">= 1.3.4", "~> 1.3"
  spec.add_dependency "rack-protection", "~> 1.4"
end