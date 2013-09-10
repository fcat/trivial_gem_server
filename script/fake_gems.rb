require 'rubygems'
require 'test_support/spec_faker'
require 'test_support/gem_builder'

source_dir = '/home/fabien/gems'
target_dir = './test/fixtures/gems'

specs_dir = File.join(target_dir, "specifications")
cache_dir = File.join(target_dir, "cache")

# setup Rubygems
Gem::Specification.dirs = [source_dir]
puts Gem::Specification.dirs

# prepare directory
FileUtils.mkdir_p source_dir
FileUtils.mkdir_p specs_dir
FileUtils.mkdir_p cache_dir

# announce
count = Gem::Specification.to_a.size
puts "building #{count} fake gems"
puts "source is #{source_dir}"
puts "target is #{target_dir}"

# fake specs and build gems
Gem::Specification.each do |spec|
  spec_file = SpecFaker.new(spec, specs_dir).save
  puts spec_file

  gem_file = GemBuilder.new(spec_file, cache_dir).build
  puts gem_file
end

puts "done"
