require 'id3_tags'
require_relative '../helpers/duplicate_file_helper'

describe Id3Tags do
  it 'does not alter tracks after reading AND writing the metadata' do
    original = File.join File.dirname(__FILE__), '../assets/all_id3.mp3'
    original_id3_tags = Id3Tags.read_tags_from(original)
    with_duplicate_file_of(original) do |duplicate|
      Id3Tags.write_tags_to(duplicate, original_id3_tags)
      Id3Tags.read_tags_from(duplicate).should == original_id3_tags
      FileUtils.identical?(original, duplicate).should be_true
    end
  end
end