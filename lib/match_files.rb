module MatchFiles

  # Returns a processor that mimicks Git ignore behavior
  def self.git(root, patterns = nil)
    return MatchFiles::GitignoreProcessor.new(root, patterns)
  end

end

require_relative('match_files/processor.rb')
require_relative('match_files/gitignore_processor')


