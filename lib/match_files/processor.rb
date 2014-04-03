require('pathname')

# This is a base class for all processors. It matches all files.
class MatchFiles::Processor
  attr_reader :match_patterns
  attr_reader :root

  def initialize(root, patterns = [])
    @root = absolute_path(root.to_s)

    if !Dir.exist?(@root)
      raise ArgumentError
    end

    @match_patterns = patterns.map {|x| x.to_s}.select{|x| !x.empty?}
  end

  # Returns true if the path given is matched.
  def matched?(path)
    true
  end

  # Recursively lists all files in the root directory relative to the root directory.
  def all_files
    Dir.chdir(@root) do
      Dir.glob("**/*", File::FNM_DOTMATCH).reject {|fn| File.directory?(fn)}
    end
  end

  # Returns list of matched files in the root folder
  def matched_files
    all_files.select {|x| matched?(x)}
  end

  # Returns list of files in the root folder which are not matched.
  def unmatched_files
    all_files.select {|x| !matched?(x)}
  end

  protected

  def absolute_path(path)
    File.expand_path(path)
  end
end
