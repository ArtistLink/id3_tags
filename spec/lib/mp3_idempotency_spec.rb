require 'spec_helper'
require 'id3_tags'

describe 'Reading ID3 from a file and writing them back to the same file' do
  context 'given an MP3 with no ID3 metadata' do
    let(:old) { asset_file('no_id3.mp3') }
    it 'maintains the original ID3 and the same exact file content' do
      read_and_write_tags_for(old) do |new|
        Id3Tags.read_tags_from(new).should == Id3Tags.read_tags_from(old)
        FileUtils.identical?(old, new).should be_true
      end
    end
  end

  context 'given an MP3 with all the ID3 metadata' do
    let(:old) { asset_file('all_id3.mp3') }
    it 'maintains the original ID3 and the same exact file content' do
      read_and_write_tags_for(old) do |new|
        Id3Tags.read_tags_from(new).should == Id3Tags.read_tags_from(old)
        FileUtils.identical?(old, new).should be_true
      end
    end
  end
end