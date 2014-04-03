module MatchFiles

  # Returns a processor that mimicks Git ignore behavior
  def self.git(root, patterns = nil)
    return MatchFiles::GitignoreMatcher.new(root, patterns)
  end

end

require_relative('match_files/matcher.rb')
require_relative('match_files/gitignore_matcher')


