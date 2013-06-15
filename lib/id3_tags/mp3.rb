require 'taglib'
require 'active_support/core_ext/hash'

module Id3Tags
  class MPEG
    def read_tags_from(file_path)
      attrs = {}
      TagLib::MPEG::File.open(file_path) do |file|
        tag_fields.each do |field, opts|
          value = file.tag.send opts[:method]
          assign! attrs, field, value, opts[:type]
        end unless file.tag.nil?
  
        audio_properties_fields.each do |field, opts|
          value = file.audio_properties.send opts[:method]
          assign! attrs, field, value, :integer
        end unless file.audio_properties.nil?
  
        id3v2_tag_fields.each do |field, opts|
          value = file.id3v2_tag.frame_list(opts[:frame_id]).first
          value = value.to_string if value and opts[:type] != :image
          assign! attrs, field, value, opts[:type]
        end unless file.id3v2_tag.nil?
      end
  
      attrs.symbolize_keys
    end

    def write_tags_to(file_path, attrs = {})
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

  private

    def fields
      {
      title:        {on: :tag, method: :title, type: :string},
      album:        {on: :tag, method: :album, type: :string},
      artist:       {on: :tag, method: :artist, type: :string},
      comment:      {on: :tag, method: :comment, type: :string},
      genre:        {on: :tag, method: :genre, type: :string},
      year:         {on: :tag, method: :year, type: :integer, default: 0},
      bpm:          {on: :id3v2_tag, frame_id: 'TBPM', type: :integer},
      lyrics:       {on: :id3v2_tag, frame_id: 'USLT', type: :text},
      composer:     {on: :id3v2_tag, frame_id: 'TCOM', type: :string},
      grouping:     {on: :id3v2_tag, frame_id: 'TIT1', type: :string},
      album_artist: {on: :id3v2_tag, frame_id: 'TPE2', type: :string},
      compilation:  {on: :id3v2_tag, frame_id: 'TCMP', type: :boolean},
      track:        {on: :id3v2_tag, frame_id: 'TRCK', type: :pair},
      disk:         {on: :id3v2_tag, frame_id: 'TPOS', type: :pair},
      cover_art:    {on: :id3v2_tag, frame_id: 'APIC', type: :image},
      bitrate:      {on: :audio_properties, method: :bitrate},
      channels:     {on: :audio_properties, method: :channels},
      length:       {on: :audio_properties, method: :length},
      samplerate:   {on: :audio_properties, method: :sample_rate},
      }
    end

    def tag_fields
      fields.select{|k,v| v[:on] == :tag}
    end

    def audio_properties_fields
      fields.select{|k,v| v[:on] == :audio_properties }
    end

    def id3v2_tag_fields
      fields.select{|k,v| v[:on] == :id3v2_tag }
    end

    def assign!(attrs, field, value, type)
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

    def new_frame_for(content, frame_id, type)
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

    def new_string_frame(frame_id)
      TagLib::ID3v2::TextIdentificationFrame.new frame_id, TagLib::String::UTF8
    end

    def new_text_frame(frame_id)
      TagLib::ID3v2::UnsynchronizedLyricsFrame.new frame_id
    end

    def new_image_frame(frame_id)
      TagLib::ID3v2::AttachedPictureFrame.new frame_id
    end
  end
end