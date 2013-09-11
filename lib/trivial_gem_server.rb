require 'rubygems'
require 'sinatra/base'
require 'syck'
require 'yaml'

module YAML
  module Syck
    class DefaultKey
    end
  end
end

module TrivialGemServer
end

class TrivialGemServer::Server < Sinatra::Base
  configure :production, :development do
    set :gem_dirs, Array(ENV['GEM_DIR'] || Gem.path)
  end

  configure :test do
    set :gem_dirs, Array(File.expand_path('../../test/fixtures/gems', __FILE__))
  end

  before do
    # don't set up gem_dirs in configure!
    # you would loose your gem set and fallback to webrick!
    Gem::Specification.dirs = settings.gem_dirs
  end

  get '/' do
    render_text_for_specs all_specs
  end

  get '/specs.txt' do
    render_text_for_specs all_specs
  end

  get '/latest_specs.txt' do
    render_text_for_specs latest_specs
  end

  get '/specs.4.8.gz' do
    send_gip_for_specs all_specs
  end

  get '/latest_specs.4.8.gz' do
    send_gip_for_specs latest_specs
  end

  get '/gems/:filename' do
    if path = find_package_path(params[:filename])
      send_file path
    else
      halt 404, "#{params[:filename]} not found!"
    end
  end

  get '/quick/Marshal.4.8/:fullname.gemspec.rz' do
    specs = find_specs_by_fullname(params[:fullname])
    if specs.empty? then
      halt 404, "Gem #{params[:fullname]} not found"
    elsif specs.length > 1 then
      halt 500, "Multiple gems found when only one expected!"
    else
      send_rz_for_spec specs.first
    end
  end

  private

  def all_specs
    Gem::Specification.to_a
  end

  def latest_specs
    Gem::Specification.latest_specs
  end

  def render_text_for_specs specs
    content_type 'text/plain'
    specs.map do |s|
      [s.name, s.version.to_s].join('-')
    end.join("\n")
  end

  def send_gip_for_specs(specs)
    overview = specs.sort_by(&:sort_obj).map do |spec|
      platform = spec.original_platform || Gem::Platform::RUBY
      [spec.name, spec.version.to_s, platform]
    end
    content_type 'application/x-gzip'
    Gem.gzip(Marshal.dump(overview))
  end

  def find_package_path(basename)
    cache_dirs.each do |dir|
      path = File.join dir, basename
      if File.exists? path
        return path
      end
    end
    nil
  end

  def cache_dirs
    settings.gem_dirs.map { |gem_dir| File.join gem_dir, 'cache' }
  end

  def send_rz_for_spec spec
    content_type 'application/x-deflate'
    Gem.deflate(Marshal.dump(spec))
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
    specs = Gem::Specification.find_all_by_name name, version
    specs.select! { |s| s.platform == platform }
    specs
  end

end
