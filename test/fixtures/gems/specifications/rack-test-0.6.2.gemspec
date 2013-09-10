Gem::Specification.new do |spec|
  spec.name = "rack-test"
  spec.version = "0.6.2"
  spec.platform = "ruby"
  spec.date = "2012-09-27"
  spec.summary = "Simple testing API built on Rack"
  spec.description = "Rack::Test is a small, simple testing API for Rack apps. It can be used on its\nown or as a reusable starting point for Web frameworks and testing libraries\nto build on. Most of its initial functionality is an extraction of Merb 1.0's\nrequest helpers feature."
  spec.authors = ["Bryan Helmkamp"]
  spec.email = "bryan@brynary.com"
  spec.homepage = "http://github.com/brynary/rack-test"
  spec.add_dependency "rack", ">= 1.0"
end