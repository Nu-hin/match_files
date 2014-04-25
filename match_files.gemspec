require File.expand_path("../lib/match_files/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "match_files"
  s.version = ::MatchFiles::VERSION
  s.platform = Gem::Platform::RUBY
  s.date = Date.today.to_s

  s.authors = ["Nu-hin"]
  s.email = ["nuinuhin@gmail.com"]
  s.homepage = "https://github.com/Nu-hin/match_files"

  s.summary = %q{Lightweight gem that allows to match files according to the given patterns}
  s.description = %q{This gem provides a simplistic interface that allows to match files in the given directory according to given pattern.}
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]
end
