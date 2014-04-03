require 'coveralls'
Coveralls.wear!


require_relative('../lib/ignore_files.rb')

def prepare_test_dir(dirs = nil, files = nil, silence = true)
  @silence = silence
  @root = Dir.mktmpdir
  whisper "-> Test dir is #{@root}"

  dirs  ||= ['', 'a', 'a/b', 'b', 'b/c', 'c', 'c/d', 'a/b/c', 'ba', 'ba/a']
  files ||= ['readme.md', 'license.md', '1.txt', '2.txt', '1.ga']

  dirs.each do |d|
    full_d = File.join(@root, d)
    dd = Dir.mkdir(full_d) if !Dir.exist?(full_d)
    whisper "-> Created dir #{full_d}"

    files.each do |f|
      full_f = File.join(full_d, f)
      FileUtils.touch(full_f)
      whisper "-> Created file #{full_f}"
    end
  end

  @files_count = (dirs.size) * files.size
end

def clear_test_dir
  FileUtils.rm_rf(@root)
  whisper "-> Test dir #{@root} is removed"
end

def whisper(str)
  puts str if !@silence
end
