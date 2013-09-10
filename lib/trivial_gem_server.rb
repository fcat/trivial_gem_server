require 'rubygems'
require 'sinatra/base'

class TrivialGemServer::Server < Sinatra::Base
  attr_reader :gem_dirs

  def initialize *gem_dirs
    @gem_dirs = gem_dirs || Gem.path
    Gem::Specification.dirs = gem_dirs
  end

  get '/specs.4.8.gz' do
    handle_specs_request do
      Gem::Specification.to_a
    end
  end

  get '/latest_specs.4.8.gz' do
    handle_specs_request do
      Gem::Specification.latest_specs
    end
  end

  get '/gems/:basename' do
    if path = find_package_path(params[:basename])
      # TODO send file
    else
      # 404
    end
  end

  get '/quick/Marshal.4.8/:fullname.gemspec.rz' do
    specs = find_specs_by_fullname(params[:fullname])

    if specs.empty? then
      # TODO
      # res.status = 404
      # res.body = "Gem not found"
    elsif specs.length > 1 then
      # TODO
      # res.status = 500
      # res.body = "Multiple gems found matching"
    elsif marshal_format then
      # TODO
      # res['content-type'] = 'application/x-deflate'
      body = Gem.deflate(Marshal.dump(specs.first))
      # send body
    end
  end

  private

  def find_package_path(basename)
    catch(:path) do
      cache_dirs.each do |dir|
        path = File.join dir,
          if File.exists? path
            throw :path, path
          end
      end
    end
  end

  def find_specs_by_fullname(fullname)
    fullname.match /(.*?)-([0-9.]+)(-.*?)?/
    name, version, platform = $1, $2, $3

    platform = if platform then # FIXME
                 Gem::Platform.new platform.sub(/^-/, '')
               else
                 Gem::Platform::RUBY
               end

    find_specs(name, version, platform)
  end

  def find_specs(name, version, platform)
    Gem::Specification.reset
    specs = Gem::Specification.find_all_by_name name, version
    specs.select { |s| s.platform == platform }
  end

  def handle_specs_request
    # Gem::Specification.reset

    specs = yield.sort_by(&:sort_obj).map do |spec|
      platform = spec.original_platform || Gem::Platform::RUBY
      [spec.name, spec.version, platform]
    end

    headers = {'content-type' => 'application/x-gzip'}
    zipped_specs = Gem.gzip(Marshal.dump(specs))
    [200, headers, zipped_specs]
  end

  def cache_dirs
    gem_dirs.map { |gem_dir| File.join gem_dir, 'cache' }
  end

  def spec_dirs
    gem_dirs.map { |gem_dir| File.join gem_dir, 'specifications' }
  end

  def error_response(code, message)
    halt [code, message] if api_request?
    html = <<HTML
<html>
  <head><title>Error - #{code}</title></head>
  <body>
    <h1>Error - #{code}</h1>
    <p>#{message}</p>
  </body>
</html>
HTML
    halt [code, html]
  end
end
