require 'pathname'
require 'fileutils'

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
