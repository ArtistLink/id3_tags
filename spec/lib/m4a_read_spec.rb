require 'spec_helper'
require 'id3_tags'

describe 'Id3Tags.read_tags_from' do
  context 'given an M4A with all the ID3 metadata' do
    let(:track_with_metadata) { asset_file('all_id3.m4a') }

    it 'returns all the ID3 tag with the right value' do
      id3_tags = Id3Tags.read_tags_from track_with_metadata

      id3_tags.keys.should =~ [:album, :artist, :comment, :genre, :samplerate,
        :track, :disk, :title, :year, :bitrate, :channels, :length, :grouping,
        :album_artist, :composer, :bpm, :lyrics, :compilation, :cover_art]
      id3_tags[:title].should == 'Sample track'
      id3_tags[:album].should == 'Sample album'
      id3_tags[:artist].should == 'Sample artist'
      id3_tags[:comment].should == 'Sample comments'
      id3_tags[:genre].should == 'Sample Genre'
      id3_tags[:year].should == 1979
      id3_tags[:track][:number].should == 3
      id3_tags[:track][:count].should == 12
      id3_tags[:disk][:number].should == 1
      id3_tags[:disk][:count].should == 2
      id3_tags[:bitrate].should == 586
      id3_tags[:channels].should == 2
      id3_tags[:length].should == 38
      id3_tags[:samplerate].should == 44100
      id3_tags[:album_artist].should == 'Sample album artist'
      id3_tags[:composer].should == 'Sample composer'
      id3_tags[:grouping].should == 'Sample group'
      id3_tags[:bpm].should == 110
      id3_tags[:lyrics].should == "Sample lyrics line 1\rand line 2"
      id3_tags[:compilation].should be_true
      id3_tags[:cover_art][:mime_type].should == 'image/png'
      id3_tags[:cover_art][:data].length.should == 3368
    end
  end

  context 'given an M4A with no ID3 metadata' do
    let(:track_with_metadata) { asset_file('no_id3.m4a') }

    it 'returns all the ID3 tag with a nil value' do
      id3_tags = Id3Tags.read_tags_from track_with_metadata

      id3_tags.keys.should =~ [:album, :artist, :comment, :genre, :samplerate,
        :track, :disk, :title, :year, :bitrate, :channels, :length, :grouping,
        :album_artist, :composer, :bpm, :lyrics, :compilation, :cover_art]

      id3_tags[:title].should == ' ' # can never be nil
      id3_tags[:album].should be_nil
      id3_tags[:artist].should be_nil
      id3_tags[:comment].should be_nil
      id3_tags[:genre].should be_nil
      id3_tags[:year].should == 0 # can never be nil
      id3_tags[:track][:number].should be_nil
      id3_tags[:track][:count].should be_nil
      id3_tags[:disk][:number].should be_nil
      id3_tags[:disk][:count].should be_nil
      id3_tags[:bitrate].should == 585 # can never be nil
      id3_tags[:channels].should == 2 # can never be nil
      id3_tags[:length].should == 38 # can never be nil
      id3_tags[:samplerate].should == 44100 # can never be nil
      id3_tags[:album_artist].should be_nil
      id3_tags[:composer].should be_nil
      id3_tags[:grouping].should be_nil
      id3_tags[:bpm].should be_nil
      id3_tags[:lyrics].should be_nil
      id3_tags[:compilation].should be_false
      id3_tags[:cover_art][:mime_type].should be_nil
      id3_tags[:cover_art][:data].should be_nil
    end
  end
end