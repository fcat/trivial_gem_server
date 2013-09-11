require 'test_helper'

class ServeSpecsTest < TrivialGemServer::TestCase
  include Rack::Test::Methods

  def test_it_serve_all_specs
    get '/specs.4.8.gz'
    assert last_response.ok?
    assert_equal extract_zipped_specs(last_response.body), [
      ["builder", "3.2.2", "ruby"],
      ["rack", "1.4.0", "ruby"],
      ["rack", "1.3.0", "ruby"],
      ["rack", "1.5.0", "ruby"],
      ["rack-protection", "1.5.0", "ruby"],
      ["rack-test", "0.6.2", "ruby"],
      ["sinatra", "1.3.3", "ruby"],
      ["sinatra", "1.4.3", "ruby"],
      ["tilt", "1.4.1", "ruby"]].sort
  end

  def test_it_serve_latest_specs
    get '/latest_specs.4.8.gz'
    assert last_response.ok?
    assert_equal extract_zipped_specs(last_response.body), [
      ["builder", "3.2.2", "ruby"],
      ["rack", "1.5.0", "ruby"],
      ["rack-protection", "1.5.0", "ruby"],
      ["rack-test", "0.6.2", "ruby"],
      ["sinatra", "1.4.3", "ruby"],
      ["tilt", "1.4.1", "ruby"]].sort
  end

  private

  def extract_zipped_specs(raw)
    Marshal.load(Gem.gunzip(raw)).sort
  end

end
