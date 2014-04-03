module IgnoreFiles

  # Returns a processor that mimicks Git ignore behavior
  def self.git(root, patterns = nil)
    return IgnoreFiles::GitignoreProcessor.new(root, patterns)
  end

end

require_relative('ignore_files/processor.rb')
require_relative('ignore_files/gitignore_processor')


