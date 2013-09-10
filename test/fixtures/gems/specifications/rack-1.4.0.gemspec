Gem::Specification.new do |spec|
  spec.name = "rack"
  spec.version = "1.4.0"
  spec.platform = "ruby"
  spec.date = "2011-12-28"
  spec.summary = "a modular Ruby webserver interface"
  spec.description = "Rack provides a minimal, modular and adaptable interface for developing\nweb applications in Ruby.  By wrapping HTTP requests and responses in\nthe simplest way possible, it unifies and distills the API for web\nservers, web frameworks, and software in between (the so-called\nmiddleware) into a single method call.\n\nAlso see http://rack.rubyforge.org.\n"
  spec.authors = ["Christian Neukirchen"]
  spec.email = "chneukirchen@gmail.com"
  spec.homepage = "http://rack.rubyforge.org"
  spec.add_dependency "bacon", ">= 0"
  spec.add_dependency "rake", ">= 0"
  spec.add_dependency "ruby-fcgi", ">= 0"
  spec.add_dependency "memcache-client", ">= 0"
  spec.add_dependency "mongrel", ">= 1.2.0.pre2"
  spec.add_dependency "thin", ">= 0"
end