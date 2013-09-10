require 'rubygems'
require 'pathname'

class GemBuilder
  attr_reader :spec_file, :dir

  def initialize(spec_file, dir='.')
    @spec_file = spec_file
    @dir = Pathname.new(File.expand_path(dir))
  end

  def build
    Dir.chdir dir do
      system "gem build #{spec_file}"
    end
    raise "Failed to build gem #{name}" unless File.exists? path
    path.to_s
  end

  private

  def path
    dir.join(filename)
  end

  def filename
    File.basename(spec_file).gsub(/gemspec/, 'gem')
  end
end

class SpecFaker
  attr_reader :spec, :dir

  def initialize(spec, dir='.')
    @spec = spec
    @dir = Pathname.new(File.expand_path(dir))
  end

  def save
    File.open path, 'w' do |f|
      f.write self.to_s
    end
    path.to_s
  end

  def to_s
    "Gem::Specification.new do |spec|\n#{lines}\nend"
  end

  def path
    File.join dir, filename
  end

  private

  def filename
    File.basename spec.spec_file
  end

  def lines
    fields_lines.concat(add_dependency_lines).join("\n")
  end

  def fields_lines
    fields.map do |(key, value)|
      "  spec.#{key} = #{value.inspect}"
    end
  end

  def fields
    a = []
    a << ['name', spec.name]
    a << ['version', spec.version.to_s]
    a << ['platform', spec.platform]
    a << ['date', spec.date.to_s.split(/\s+/).first]
    %w{summary description authors email homepage}.each do |key|
      a << [key, spec.send(key)]
    end
    a
  end

  def add_dependency_lines
    add_dependency_args.map do |args|
      s = args.map do |a| a.inspect end.join(', ')
      "  spec.add_dependency #{s}"
    end
  end

  def add_dependency_args
    spec.dependencies.map do |dep|
      args = dep.requirements_list
      args.unshift dep.name
      args
    end
  end
end
