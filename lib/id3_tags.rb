require 'taglib'
require 'active_support/core_ext/hash'

# Provides two methods to read and write ID3 metadata from an MP3 file
module Id3Tags

  # Returns a Hash of ID3 attributes stored in the file located at +file_path+.
  #
  # @param [String] file_path Local path to an MP3 file
  # @return [Hash] the ID3 attributes stored in the file
  #
  # @example Read tags from an MP3 full of metadata
  #   Id3Tags.read_tags_from("all_id3.mp3")
  #
  #    # => {title: "Sample track", album: "Sample album", artist: Sample
  #          artist", :comment=>"Sample comments", genre: "Sample Genre",
  #          year: 1979, bitrate: 128, channels: 2, length: 38, samplerate:
  #          44100, bpm: 110, lyrics: "Sample lyrics line 1\rand line 2",
  #          composer: "Sample composer", grouping: "Sample group",
  #          album_artist: "Sample album artist", compilation: true, track:
  #          {number: 3, count: 12}, disk: {number: 1, count: 2}, cover_art:
  #          {mime_type: "image/png", data: "\x89PNG\r\n\x1A[...]"}}
  def self.read_tags_from(file_path)
    attrs = {}
    TagLib::MPEG::File.open(file_path) do |file|
      tag_fields.each do |field, opts|
        value = file.tag.send opts[:method]
        assign! attrs, field, value, opts[:type]
      end unless file.tag.nil?

      audio_properties_fields.each do |field, opts|
        value = file.audio_properties.send opts[:method]
        assign! attrs, field, value, opts[:type]
      end unless file.audio_properties.nil?

      id3v2_tag_fields.each do |field, opts|
        value = file.id3v2_tag.frame_list(opts[:frame_id]).first
        value = value.to_string if value and opts[:type] != :image
        assign! attrs, field, value, opts[:type]
      end unless file.id3v2_tag.nil?
    end

    attrs.symbolize_keys
  end

  # Stores the +attrs+ Hash of ID3 attributes into the file at +file_path+.
  #
  # @param [String] file_path Local path to an MP3 file
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
  #    # => true
  def self.write_tags_to(file_path, attrs = {})
    attrs.symbolize_keys!

    TagLib::MPEG::File.open(file_path) do |file|
      tag_fields.each do |field, opts|
        file.tag.send "#{opts[:method]}=", (attrs[field] || opts[:default])
      end unless file.tag.nil?

      id3v2_tag_fields.each do |field, opts|
        file.id3v2_tag.remove_frames opts[:frame_id]
        frame = new_frame_for attrs[field], opts[:frame_id], opts[:type]
        file.id3v2_tag.add_frame frame if frame
      end unless file.id3v2_tag.nil?

      file.save
    end
  end

  # @private
  def self.fields
    {
    title:       {on: :tag, method: :title, type: :string},
    album:       {on: :tag, method: :album, type: :string},
    artist:      {on: :tag, method: :artist, type: :string},
    comment:     {on: :tag, method: :comment, type: :string},
    genre:       {on: :tag, method: :genre, type: :string},
    year:        {on: :tag, method: :year, type: :integer, default: 0},
    bitrate:     {on: :audio_properties, method: :bitrate, type: :integer},
    channels:    {on: :audio_properties, method: :channels, type: :integer},
    length:      {on: :audio_properties, method: :length, type: :integer},
    samplerate:  {on: :audio_properties, method: :sample_rate, type: :integer},
    bpm:         {on: :id3v2_tag, frame_id: 'TBPM', type: :integer},
    lyrics:      {on: :id3v2_tag, frame_id: 'USLT', type: :text},
    composer:    {on: :id3v2_tag, frame_id: 'TCOM', type: :string},
    grouping:    {on: :id3v2_tag, frame_id: 'TIT1', type: :string},
    album_artist:{on: :id3v2_tag, frame_id: 'TPE2', type: :string},
    compilation: {on: :id3v2_tag, frame_id: 'TCMP', type: :boolean},
    track:       {on: :id3v2_tag, frame_id: 'TRCK', type: :pair},
    disk:        {on: :id3v2_tag, frame_id: 'TPOS', type: :pair},
    cover_art:   {on: :id3v2_tag, frame_id: 'APIC', type: :image},
    }
  end

  # @private
  def self.tag_fields
    fields.select{|k,v| v[:on] == :tag}
  end

  # @private
  def self.audio_properties_fields
    fields.select{|k,v| v[:on] == :audio_properties }
  end

  # @private
  def self.id3v2_tag_fields
    fields.select{|k,v| v[:on] == :id3v2_tag }
  end

  # @private
  def self.assign!(attrs, field, value, type)
    case type
    when :string, :text
      attrs[field] = value && value.to_s
    when :integer
      attrs[field] = value && value.to_i
    when :boolean
      attrs[field] = value.present? && value.eql?('1')
    when :pair
      pair = value ? value.split('/').map(&:to_i) : [nil, nil]
      attrs[field] = {number: pair[0], count: pair[1]}
    when :image
      pair = [value && value.mime_type, value && value.picture].map(&:presence)
      attrs[field] = {mime_type: pair[0], data: pair[1]}
    end
  end

  # @private
  def self.new_frame_for(content, frame_id, type)
    return if content.nil?
    case type
    when :string, :integer
      frame = new_string_frame(frame_id)
      frame.text = content.to_s
    when :text
      frame = new_text_frame(frame_id)
      frame.text = content.to_s
    when :boolean
      return unless content.eql?(true)
      frame = new_string_frame(frame_id)
      frame.text = '1'
    when :pair
      return unless content.has_key? :number
      frame = new_string_frame(frame_id)
      frame.text = content.values_at(:number, :count).compact.join '/'
    when :image
      return unless content.has_key? :data
      frame = new_image_frame(frame_id)
      frame.description = 'Cover'
      frame.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
      frame.mime_type = content[:mime_type]
      frame.picture = content[:data]
    end
    frame
  end

  # @private
  def self.new_string_frame(frame_id)
    TagLib::ID3v2::TextIdentificationFrame.new frame_id, TagLib::String::UTF8
  end

  # @private
  def self.new_text_frame(frame_id)
    TagLib::ID3v2::UnsynchronizedLyricsFrame.new frame_id
  end

  # @private
  def self.new_image_frame(frame_id)
    TagLib::ID3v2::AttachedPictureFrame.new frame_id
  end
end