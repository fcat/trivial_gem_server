require 'test_helper'
require 'digest'

class GetGemspecTest < TrivialGemServer::TestCase
  include Rack::Test::Methods

  def test_it_returns_gem
    get '/gems/rack-1.5.0.gem'
    assert last_response.ok?
    assert_equal 'application/octet-stream', content_type

    source_file = File.expand_path(
      '../../fixtures/gems/cache/rack-1.5.0.gem', __FILE__)
    expected = File.read source_file
    assert expected == last_response.body, "response does not match #{source_file} content"
  end

  def test_raises_when_no_gem
    get '/gems/missing-1.0.0.gem'
    assert !last_response.ok?
    assert_equal 404, last_response.status
    assert last_response.body.match /not found/i
  end

  private

  def content_type
    last_response.content_type.split(';')[0]
  end

end
