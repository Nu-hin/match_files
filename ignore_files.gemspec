require File.expand_path("../lib/ignore_files/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "ignore_files"
  s.version = ::IgnoreFiles::VERSION
  s.authors = ["Nu-hin"]
  s.email = ["nuinuhin@gmail.com"]
  s.homepage = "https://github.com/Nu-hin/ignore_files"

  s.summary = %q{Lightweight gem that allows to ignore files according to the given patterns}
  s.description = %q{This gem provides a simplistic interface that allows to ignore files in the given directory according to given pattern.}
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]
end
