require 'test_helper'

class GetGemspecTest < TrivialGemServer::TestCase
  include Rack::Test::Methods

  def test_it_serve_spec_as_rz
    get '/quick/Marshal.4.8/rack-1.5.0.gemspec.rz'
    assert last_response.ok?
    assert_equal 'application/x-deflate', content_type
    spec = extract_rz_spec
    assert_equal Gem::Specification, spec.class
    assert_equal 'rack', spec.name
    assert_equal Gem::Version.new('1.5.0'), spec.version
    assert_equal 'ruby', spec.platform
  end

  def test_raises_when_no_spec
    get '/quick/Marshal.4.8/rack-missing-1.5.0.gemspec.rz'
    assert !last_response.ok?
    assert_equal 404, last_response.status
    assert last_response.body.match /not found/i
  end

  def test_raises_when_multiple_specs
    skip "TODO: create many gems for different platform, and query with no platform in params"
  end

  private

  def content_type
    last_response.content_type.split(';')[0]
  end

  def extract_rz_spec
    raw = last_response.body
    Marshal.load(Gem.inflate(raw))
  end

end
