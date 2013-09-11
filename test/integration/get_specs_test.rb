require 'test_helper'

class GetSpecsTest < TrivialGemServer::TestCase
  include Rack::Test::Methods

  def test_it_returns_all_specs_as_text
    get '/specs.txt'
    assert last_response.ok?
    assert_equal 'text/plain', content_type
    assert_equal "builder-3.2.2
rack-1.4.0
rack-1.3.0
rack-1.5.0
rack-protection-1.5.0
rack-test-0.6.2
sinatra-1.3.3
sinatra-1.4.3
tilt-1.4.1".split.sort,
      last_response.body.split.sort
  end

  def test_it_returns_latest_specs_as_text
    get '/latest_specs.txt'
    assert last_response.ok?
    assert_equal 'text/plain', content_type
    assert_equal last_response.body.split.sort,
"builder-3.2.2
rack-1.5.0
rack-protection-1.5.0
rack-test-0.6.2
sinatra-1.4.3
tilt-1.4.1".split.sort
  end

  def test_it_returns_all_specs_as_gzip
    get '/specs.4.8.gz'
    assert last_response.ok?
    assert_equal 'application/x-gzip', content_type
    assert_equal [
      ["builder", "3.2.2", "ruby"],
      ["rack", "1.4.0", "ruby"],
      ["rack", "1.3.0", "ruby"],
      ["rack", "1.5.0", "ruby"],
      ["rack-protection", "1.5.0", "ruby"],
      ["rack-test", "0.6.2", "ruby"],
      ["sinatra", "1.3.3", "ruby"],
      ["sinatra", "1.4.3", "ruby"],
      ["tilt", "1.4.1", "ruby"]].sort,
      extract_zipped_specs
  end

  def test_it_returns_latest_specs_as_gzip
    get '/latest_specs.4.8.gz'
    assert last_response.ok?
    assert_equal 'application/x-gzip', content_type
    assert_equal [
      ["builder", "3.2.2", "ruby"],
      ["rack", "1.5.0", "ruby"],
      ["rack-protection", "1.5.0", "ruby"],
      ["rack-test", "0.6.2", "ruby"],
      ["sinatra", "1.4.3", "ruby"],
      ["tilt", "1.4.1", "ruby"]].sort,
      extract_zipped_specs
  end

  private

  def content_type
    last_response.content_type.split(';')[0]
  end

  def extract_zipped_specs
    raw = last_response.body
    Marshal.load(Gem.gunzip(raw)).sort
  end

end
