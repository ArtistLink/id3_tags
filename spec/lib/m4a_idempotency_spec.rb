require 'spec_helper'
require 'id3_tags'

describe 'Reading ID3 from a file and writing them back to the same file' do
  context 'given an M4A with no ID3 metadata' do
    let(:old) { asset_file('no_id3.m4a') }
    it 'maintains the original ID3 tags (but the file might be different)' do
      read_and_write_tags_for(old) do |new|
        Id3Tags.read_tags_from(new).should == Id3Tags.read_tags_from(old)
        #FileUtils.identical?(old, new).should be_true
      end
    end
  end

  context 'given an M4A with all the ID3 metadata' do
    let(:old) { asset_file('all_id3.m4a') }
    it 'maintains the original ID3 and the same exact file content' do
      read_and_write_tags_for(old) do |new|
        Id3Tags.read_tags_from(new).should == Id3Tags.read_tags_from(old)
        FileUtils.identical?(old, new).should be_true
      end
    end
  end
end