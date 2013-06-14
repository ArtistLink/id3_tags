require 'id3_tags'
require_relative '../helpers/duplicate_file_helper'

describe 'Id3Tags.write_tags_to' do
  context 'given a track with all the ID3 metadata and a Hash of empty ID3' do
    let(:original_track) {File.join File.dirname(__FILE__), '../assets/all_id3.mp3'}
    let(:new_metadata) { {} }

    it 'resets all the editable ID3 tags of the track to nil' do
      with_duplicate_file_of(original_track) do |duplicate|
        Id3Tags.write_tags_to(duplicate, new_metadata)
        id3_tags = Id3Tags.read_tags_from(duplicate)
        [:album, :artist, :comment, :genre, :title, :grouping, :lyrics,
         :album_artist, :composer, :bpm].each do |field|
          id3_tags[field].should be_nil
        end
        id3_tags[:year].should == 0
        id3_tags[:compilation].should be_false
        # NOTE: Taglib does NOT allow the track_number to be nil; the old
        #       value is persisted in this case, so we cannot test for nil?
        #id3_tags[:track][:number].should be_nil
        id3_tags[:track][:count].should be_nil
        id3_tags[:disk][:number].should be_nil
        id3_tags[:disk][:count].should be_nil
        id3_tags[:cover_art][:mime_type].should be_nil
        id3_tags[:cover_art][:data].should be_nil
      end
    end
  end

  context 'given a track with no metadata and a Hash full of ID3' do
    let(:original_track) {File.join File.dirname(__FILE__), '../assets/no_id3.mp3'}
    let(:new_cover_art) {File.join File.dirname(__FILE__), '../assets/black_pixel.png'}
    let(:new_cover_art_data) {File.open(new_cover_art, 'rb') {|io| io.read}}
    let(:new_metadata) { {title: "A track", album: "An album", artist:
      "An artist", year: 2012, comment: "A comment", genre: "A genre", bpm: 68,
      composer: "A composer", lyrics: "A lyrics line 1\rand line 2",
      album_artist: "An album artist", grouping: "A group", compilation: true,
      track: {number: 1, count: 24}, disk: {number: 1, count: 2}, cover_art:
      {mime_type: "image/png", data: new_cover_art_data}}
    }

    it 'sets all the editable ID3 tags of a track' do
      with_duplicate_file_of(original_track) do |duplicate|
        Id3Tags.write_tags_to(duplicate, new_metadata)
        id3_tags = Id3Tags.read_tags_from(duplicate)
        id3_tags[:album].should == 'An album'
        id3_tags[:artist].should == 'An artist'
        id3_tags[:comment].should == 'A comment'
        id3_tags[:genre].should == 'A genre'
        id3_tags[:title].should == 'A track'
        id3_tags[:grouping].should == 'A group'
        id3_tags[:lyrics].should == "A lyrics line 1\rand line 2"
        id3_tags[:album_artist].should == 'An album artist'
        id3_tags[:composer].should == 'A composer'
        id3_tags[:bpm].should == 68
        id3_tags[:compilation].should be_true
        id3_tags[:track][:number].should == 1
        id3_tags[:track][:count].should == 24
        id3_tags[:disk][:number].should == 1
        id3_tags[:disk][:count].should == 2
        id3_tags[:cover_art][:mime_type].should == 'image/png'
        id3_tags[:cover_art][:data].should == new_cover_art_data
      end
    end
  end
end