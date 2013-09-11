$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'trivial_gem_server'

run TrivialGemServer::Server
