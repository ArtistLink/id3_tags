# coding: utf-8
require 'taglib'
require 'active_support/core_ext/hash'

module Id3Tags
  class M4A
    def read_tags_from(file_path)
      attrs = {}
      TagLib::MP4::File.open(file_path) do |file|
        tag_fields.each do |field, opts|
          value = file.tag.item_list_map.fetch opts[:frame_id]
          assign! attrs, field, value, opts[:type], opts[:default]
        end unless file.tag.nil?

        audio_properties_fields.each do |field, opts|
          value = file.audio_properties.send opts[:method]
          assign! attrs, field, value, :integer
        end unless file.audio_properties.nil?
      end
      attrs.symbolize_keys
    end

    def write_tags_to(file_path, attrs = {})
      attrs.symbolize_keys!

      TagLib::MP4::File.open(file_path) do |file|
        tag_fields.each do |field, opts|
          file.tag.item_list_map.erase opts[:frame_id]
          frame = new_frame_for attrs[field], opts[:frame_id], opts[:type]
          file.tag.item_list_map.insert opts[:frame_id], frame if frame
        end unless file.tag.nil?

        file.save
      end
    end

  private

    def fields
      {
      album_artist: {on: :tag, frame_id: 'aART', type: :string},
      artist:       {on: :tag, frame_id: '©ART', type: :string},
      title:        {on: :tag, frame_id: '©nam', type: :string},
      album:        {on: :tag, frame_id: '©alb', type: :string},
      comment:      {on: :tag, frame_id: '©cmt', type: :string},
      genre:        {on: :tag, frame_id: '©gen', type: :string},
      grouping:     {on: :tag, frame_id: '©grp', type: :string},
      lyrics:       {on: :tag, frame_id: '©lyr', type: :string},
      composer:     {on: :tag, frame_id: '©wrt', type: :string},
      year:         {on: :tag, frame_id: '©day', type: :string, default: 0},
      disk:         {on: :tag, frame_id: 'disk', type: :pair},
      track:        {on: :tag, frame_id: 'trkn', type: :pair},
      bpm:          {on: :tag, frame_id: 'tmpo', type: :integer},
      compilation:  {on: :tag, frame_id: 'cpil', type: :boolean},
      cover_art:    {on: :tag, frame_id: 'covr', type: :image},
      bitrate:      {on: :audio_properties, method: :bitrate},
      channels:     {on: :audio_properties, method: :channels},
      length:       {on: :audio_properties, method: :length},
      samplerate:   {on: :audio_properties, method: :sample_rate},
      }
    end

    def assign!(attrs, field, value, type, default = nil)
      case type
      when :string
        attrs[field] = value && value.to_string_list.first
        if default
          if attrs[field]
            attrs[field] = attrs[field].to_i
          else
            attrs[field] = default
          end
        end
      when :integer
        attrs[field] = value && value.to_int
        if attrs[field] == 0 # well... always? or just bpm?
          attrs[field] = nil
        end
      when :boolean
        attrs[field] = value && value.to_bool
      when :pair
        pair = value ? value.to_int_pair : [nil, nil]
        attrs[field] = {number: pair[0], count: pair[1]}
      when :image
        if value
          image = value.to_cover_art_list.first
          data = image.data
          mime_type = case image.format
            when TagLib::MP4::CoverArt::JPEG then 'image/jpeg'
            when TagLib::MP4::CoverArt::PNG then 'image/png'
          end
        else
          data, mime_type = [nil, nil]
        end
        attrs[:cover_art] = {data: data, mime_type: mime_type}
      end
    end

    def tag_fields
      fields.select{|k,v| v[:on] == :tag}
    end

    def audio_properties_fields
      fields.select{|k,v| v[:on] == :audio_properties }
    end

    def new_frame_for(content, frame_id, type)
      return if content.nil?
      case type
      when :string
        TagLib::MP4::Item.from_string_list [content.to_s]
      when :integer
        TagLib::MP4::Item.from_int content.to_i
      when :boolean
        TagLib::MP4::Item.from_bool content
      when :pair
        return unless content.has_key? :number
        TagLib::MP4::Item.from_int_pair content.values_at(:number, :count)
      when :image
        return unless content.has_key? :data
        mime_type = case content[:mime_type]
          when 'image/jpeg' then TagLib::MP4::CoverArt::JPEG
          when 'image/png' then TagLib::MP4::CoverArt::PNG
        end
        cover_art = TagLib::MP4::CoverArt.new mime_type, content[:data]
        TagLib::MP4::Item.from_cover_art_list [cover_art]
      end
    end
  end
end