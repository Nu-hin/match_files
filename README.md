# match_files

[![Build Status](https://travis-ci.org/Nu-hin/match_files.svg?branch=master)](https://travis-ci.org/Nu-hin/match_files)
[![Gem Version](https://badge.fury.io/rb/match_files.svg)](http://badge.fury.io/rb/match_files)
[![Coverage Status](https://coveralls.io/repos/Nu-hin/match_files/badge.png?branch=master)](https://coveralls.io/r/Nu-hin/match_files?branch=master)
[![Code Climate](https://codeclimate.com/github/Nu-hin/match_files.png)](https://codeclimate.com/github/Nu-hin/match_files)

## Description

This gem provides a simplistic interface allowing to match files in the given directory according to the given pattern.

Currently only [Git .gitignore format](https://www.kernel.org/pub/software/scm/git/docs/gitignore.html "gitignore documentation") is supported.

If you are developing an application or a library that processes files in a given folder, you might want to give your user an opportunity to specify which files should be processed (or ignored) in configuration. This gem allows you to do it gracefully using well-known Git ignore pattern format.

*match_files* doesn't have any dependencies and doesn't need Git to be installed.

## Installation

To install this gem type the following in your command line:
```bash
  gem install match_files
```
If you are using Bundler add the following line to your Gemfile:
```ruby
  gem 'match_files'
```

If you prefer to install the most up-to-date development version, add

```ruby
  gem 'match_files', git: 'git@github.com:Nu-hin/match_files.git', branch: 'master'
```

## Usage

### Specifying match patterns explicitly

```ruby
require 'match_files'

matcher = MatchFiles.git('path/to/my/dir', ['*.swp', '*.swx', '/vendor'])

all_files = matcher.all_files # list all files ins the directory recursively
ignored_files = matcher.matched_files # list only matched files
files_to_process = matcher.unmatched_files # list only files that are NOT matched

files_to_process.each.do |file|
  # do some processing here
end
```

### Using .gitignore file

```ruby
require 'match_files'

patterns = File.readlines('path/to/my/dir/.gitignore')

matcher = MatchFiles.git('path/to/my/dir', patterns)

files_to_process = matcher.unmatched_files # list only files that are NOT ignored

files_to_process.each.do |file|
  # do some processing here
end
```

### Using Git negative patterns
```ruby
require 'match_files'

# match all Ruby files, except those under /vendor directory
matcher = MatchFiles.git('path/to/my/dir', ['*.rb', '!/vendor'])

ruby_files = matcher.matched_files

ruby_files.each do |ruby_file|
  # do some code analysis
end
```

### Testing specific files

```ruby
require 'match_files'

matcher = MatchFiles.git('path/to/my/dir', ['/spec/**/*_spec.rb'])

# check if our file is spec
# use paths relative to the root directory without leading slash
is_spec = matcher.matched?('spec/lib/match_files_spec.rb')
```

### Extending

If you wish to create your own matchers, simply inherit your class from `MatchFiles::Matcher` and override at least `#matched?` method. All patterns passed to the initializer are by default stored in `@match_patterns` instance variable.

```ruby
require 'match_files'

class MyMatcher < MatchFiles::Matcher

  # file is matched if it contains any of the patterns
  def matched?(path)
    @match_patterns.any? {|mp| path.include?(mp)}
  end

end

matcher = MyMatcher.new('path/to/my/dir', ['foo', 'bar'])
is_spec = matcher.matched?('/a/b/c/foo.md') # true
```
