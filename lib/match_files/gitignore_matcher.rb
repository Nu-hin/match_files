
# This is a free interpretation of Git dir.c module at https://github.com/git/git/blob/master/dir.c
class MatchFiles::GitignoreMatcher < MatchFiles::Matcher

  def initialize(root, patterns = [])
    super
    parse_patterns
  end

  def matched?(path)
    relative_path = make_relative_path(path)
    match = @parsed_patterns.find do |parsed_pattern|
      match_parsed?(parsed_pattern, relative_path)
    end

    match.nil? ? false : !match[:negative]
  end

  protected

  def match?(pattern, relative_path)
    parsed_pattern = self.class.parse_pattern(pattern)
    match_parsed?(parsed_pattern, relative_path)
  end

  def self.parse_pattern(pattern)
    if pattern.nil? || pattern.empty? || pattern.start_with?('#')
      return nil
    end

    params = {
      source: pattern,
      negative: pattern.start_with?('!'),
      mustbedir: pattern.end_with?('/')
    }
    pn = pattern.gsub(/^!/, '')
    pn.gsub!('\!', '!')
    pn.gsub!(/\/$/, '')
    params[:nodir] = !pn.include?('/')
    params[:root] = pn.start_with?('/')
    pn = pn.gsub(/^\//, '')
    params[:pattern] = pn
    params
  end

  def match_parsed?(parsed_pattern, relative_path)
    relative_path = relative_path.gsub(/^\/*/, '')
    relative_path = relative_path.gsub(/\/*$/, '')
    full_relative_path = File.join(@root, relative_path)
    res = !(parsed_pattern[:mustbedir] && !File.directory?(full_relative_path))
    f_pattern = File.join(@root, parsed_pattern[:pattern])
    flags = parsed_pattern[:nodir] ? 0 : File::FNM_PATHNAME
    f_free_pattern = File.join(@root, "*/#{parsed_pattern[:pattern]}")
    res &&= File.fnmatch(f_pattern, full_relative_path, flags) ||
        (!parsed_pattern[:root] && File.fnmatch(f_free_pattern, full_relative_path, flags))
    has_sep = relative_path.include?(File::SEPARATOR)

    if !res && has_sep
      prefix = /(.*)\/[^\/]+$/.match(relative_path)[1]
      return match_parsed?(parsed_pattern, prefix)
    else
      return res
    end
  end

  def parse_patterns
    @parsed_patterns = @match_patterns.reverse.map {|x| self.class.parse_pattern(x)}
  end

end
