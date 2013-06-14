require 'id3_tags'
require_relative '../helpers/id3_tags_helper'

describe Id3Tags do
  context 'given an MP3' do
    let(:original) { asset_file('all_id3.mp3') }

    it 'does not alter tracks after reading AND writing the metadata' do
      original_id3_tags = Id3Tags.read_tags_from(original)
      with_duplicate_file_of(original) do |duplicate|
        Id3Tags.write_tags_to(duplicate, original_id3_tags)
        Id3Tags.read_tags_from(duplicate).should == original_id3_tags
        FileUtils.identical?(original, duplicate).should be_true
      end
    end
  end
end