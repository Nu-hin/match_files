require('pathname')

# This is a base class for all processors. It ignores all files.
class IgnoreFiles::Processor
  attr_reader :ignore_patterns
  attr_reader :root

  def initialize(root, patterns = [])
    @root = absolute_path(root.to_s)

    if !Dir.exist?(@root)
      raise ArgumentError
    end

    @ignore_patterns = patterns.map {|x| x.to_s}.select{|x| !x.empty?}
  end

  # Returns true if the path given is ignored.
  def ignored?(path)
    true
  end

  # Recursively lists all files in the root directory relative to the root directory.
  def all_files
    Dir.chdir(@root) do
      Dir.glob("**/*", File::FNM_DOTMATCH).reject {|fn| File.directory?(fn)}
    end
  end

  # Returns list of ignored files in the root folder
  def ignored_files
    all_files.select {|x| ignored?(x)}
  end

  # Returns list of files in the root folder which are not ignored.
  def not_ignored_files
    all_files.select {|x| !ignored?(x)}
  end

  protected

  def absolute_path(path)
    File.expand_path(path)
  end
end
