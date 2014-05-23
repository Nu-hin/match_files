require_relative '../../spec_helper.rb'
require 'tmpdir'
require 'fileutils'

describe 'MatchFiles::Matcher' do

    before(:all) do
      prepare_test_dir([''], ['1.txt'])
    end

    after(:all) do
      clear_test_dir
    end

    it 'should create instance' do
      processor = MatchFiles::Matcher.new(@root)
    end

    it 'should list all files' do
      processor = MatchFiles::Matcher.new(@root)
      expect(processor.all_files).to have(@files_count).items
    end

    it 'should not have unmatched files' do
      processor = MatchFiles::Matcher.new(@root)
      expect(processor.unmatched_files).to have(0).items
    end

    it 'should match all files' do
      processor = MatchFiles::Matcher.new(@root)
      expect(processor.matched_files).to have(@files_count).items
    end

    it 'should raise on non-existing dir' do
      expect do
        MatchFiles::Matcher.new('some_not_existing_dir_that_is_sure_not_to_exist')
      end.to raise_error ArgumentError
    end

  it 'should have correct root pathname' do
    matcher = MatchFiles::Matcher.new(@root)
  end

  it 'should have calculate relative paths' do
    matcher = MatchFiles::Matcher.new(@root)
    path = File.join(@root, '1.txt')
    expect(matcher.send(:make_relative_path, path)).to eq('1.txt')
  end
end
