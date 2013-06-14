require 'mimemagic'
require 'id3_tags/mp3'
require 'id3_tags/m4a'

# Provides two methods to read and write ID3 metadata from an MP3 or M4A file
module Id3Tags

  # Returns a Hash of ID3 attributes stored in the file located at +file_path+.
  #
  # @param [String] file_path Local path to an MP3 or M4A file
  # @return [Hash] the ID3 attributes stored in the file
  #
  # @example Read tags from an MP3 full of metadata
  #   Id3Tags.read_tags_from("all_id3.mp3")
  #
  #   # => {title: "Sample track", album: "Sample album", artist: Sample
  #         artist", :comment=>"Sample comments", genre: "Sample Genre",
  #         year: 1979, bitrate: 128, channels: 2, length: 38, samplerate:
  #         44100, bpm: 110, lyrics: "Sample lyrics line 1\rand line 2",
  #         composer: "Sample composer", grouping: "Sample group",
  #         album_artist: "Sample album artist", compilation: true, track:
  #         {number: 3, count: 12}, disk: {number: 1, count: 2}, cover_art:
  #         {mime_type: "image/png", data: "\x89PNG\r\n\x1A[...]"}}
  def self.read_tags_from(file_path)
    case mime_type_of(file_path)
      when 'audio/mpeg' then MPEG.new.read_tags_from(file_path)
      when 'audio/mp4' then M4A.new.read_tags_from(file_path)
      else {}
    end
  end

  # Stores the +attrs+ Hash of ID3 attributes into the file at +file_path+.
  #
  # @param [String] file_path Local path to an MP3 or M4A file
  # @param [Hash] attrs the ID3 attributes stored in the file
  # @return [Boolean] true (the file gets changed)
  #
  # @example Write ID3 tags to an MP3 file
  #   Id3Tags.write_tags_to("no_id3.mp3", {title: "Sample track", album:
  #        "Sample album", artist: Sample artist", :comment=>"Sample comments",
  #        genre: "Sample Genre", year: 1979, bitrate: 128, channels: 2,
  #        length: 38, samplerate: 44100, bpm: 110, lyrics: "Sample lyrics
  #        line 1\rand line 2", composer: "Sample composer", grouping: "Sample
  #        group", album_artist: "Sample album artist", compilation: true,
  #        track: {number: 3, count: 12}, disk: {number: 1, count: 2},
  #        cover_art: {mime_type: "image/png", data: "\x89PNG\r\n\x1A[...]"}}
  #
  #   # => true
  def self.write_tags_to(file_path, attrs = {})
    case mime_type_of(file_path)
      when 'audio/mpeg' then MPEG.new.write_tags_to(file_path, attrs)
      when 'audio/mp4' then M4A.new.write_tags_to(file_path, attrs)
      else false
    end
  end

  # Returns the MIME type of the file located at +file_path+.
  #
  # @param [String] file_path Local path to a file
  # @return [String] the MIME type of the file
  #
  # @example Return the MIME type of an M4A file with a wrong '.mp3' extension
  #   Id3Tags.mime_type_of("this_is_an_m4a.mp3")
  #
  #   # => "audio/mpeg"
  def self.mime_type_of(file_path)
    mime_type   = MimeMagic.by_magic File.open(file_path)
    mime_type ||= MimeMagic.by_path file_path
    mime_type &&= mime_type.type
  end
end