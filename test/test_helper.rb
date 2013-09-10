ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'trivial_gem_server'
require 'test/unit'
require 'rack/test'

class TrivialGemServer::TestCase < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TrivialGemServer::Server.new
  end

end
