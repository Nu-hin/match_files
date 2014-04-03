require_relative '../spec_helper'

describe 'MatchFiles' do

  it 'should create Git matcher' do
    matcher = MatchFiles.git('.', ['*.rb', '!vendor/'])
  end

end
