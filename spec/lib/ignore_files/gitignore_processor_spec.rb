require_relative '../../spec_helper.rb'
require 'tmpdir'
require 'fileutils'

describe 'IgnoreFiles::GitignoreProcessor' do

    before(:all) do
      prepare_test_dir
    end

    after(:all) do
      clear_test_dir
    end


    # Paths should match pattern
    {
      '*.md' => ['readme.md', 'usage.md', 'a/readme.md', 'a/b/c/readme.md'],
      '/*.md' => ['readme.md', 'usage.md'],
      'a/' => ['a', 'a/', 'a/readme.md', 'a/b/readme.md'],
      '*a/' => ['ba','a/ba', 'ba/a', 'a/ba/readme.md', 'ba/a/readme.md'],
      'readme.md' => ['readme.md', 'a/readme.md', 'a/b/readme.md'],
      'b/*.md' => ['a/b/readme.md', 'b/readme.md']
    }.each do |p, paths|
      [p, "!#{p}"].each do |pattern|
        paths.map{|x| [x]}.flatten.each do |path|
          it "should match path '#{path}' to pattern '#{pattern}'" do
            processor = IgnoreFiles::GitignoreProcessor.new(@root)
            expect(processor.match?(pattern, path)).to be_true
          end
        end
      end
    end


    # Paths should not match pattern
    {
      '*.md' => ['2.txt'],
      '/*.md' => ['a/readme.md'],
      'a/' => ['b', 'b/readme'],
      '*a/' => ['b/1.ga', '1.ga'],
      'e/' => ['e', 'e'],
      '/readme.md' => ['a/readme.md', 'a/b/readme.md'],
      '/b' => ['a/b/readme.md']
    }.each  do |p, paths|
      [p, "!#{p}"].each do |pattern|
        paths.map{|x| [x]}.flatten.each do |path|
          it "should not match path '#{path}' to pattern '#{pattern}'" do
            processor = IgnoreFiles::GitignoreProcessor.new(@root)
            expect(processor.match?(pattern, path)).to be_false
          end
        end
      end
    end

    it 'should create instance' do
      processor = IgnoreFiles::GitignoreProcessor.new(@root)
    end

    it 'should list all files' do
      processor = IgnoreFiles::GitignoreProcessor.new(@root)
      expect(processor.all_files).to have(@files_count).items
    end

    it 'should ignore files' do
      processor = IgnoreFiles::GitignoreProcessor.new(@root, ['*.md'])
      expect(processor.ignored_files).to have(20).items

      processor = IgnoreFiles::GitignoreProcessor.new(@root, ['*.txt'])
      expect(processor.ignored_files).to have(20).items

      processor = IgnoreFiles::GitignoreProcessor.new(@root, ['*.ga'])
      expect(processor.ignored_files).to have(10).items

      processor = IgnoreFiles::GitignoreProcessor.new(@root, ['*me.md'])
      expect(processor.ignored_files).to have(10).items

      processor = IgnoreFiles::GitignoreProcessor.new(@root, ['*se.md'])
      expect(processor.ignored_files).to have(10).items

      processor = IgnoreFiles::GitignoreProcessor.new(@root, ['/*.md'])
      expect(processor.ignored_files).to have(2).items

      processor = IgnoreFiles::GitignoreProcessor.new(@root, ['ba/*.md'])
      expect(processor.ignored_files).to have(2).items

      processor = IgnoreFiles::GitignoreProcessor.new(@root, ['b/*.md'])
      expect(processor.ignored_files).to have(4).items
    end

    it 'should not ignore files' do
      processor = IgnoreFiles::GitignoreProcessor.new(@root, ['*.md'])
      expect(processor.not_ignored_files).to have(30).items
    end

    it 'should raise on non-existing dir' do
      expect do
        IgnoreFiles::GitignoreProcessor.new('some_not_existing_dir_that_is_sure_not_to_exist', ['*.md'])
      end.to raise_error ArgumentError
    end
end
