require 'taglib'
require 'active_support/core_ext/hash'

module Id3Tags
  module M4AFieldsGetter
  private
    def get_tag_fields(file, attrs = {})
      read_tag_fields(file, attrs) do |opts|
        file.tag.item_list_map.fetch opts[:frame_id]
      end
    end

    def get_audio_properties_fields(file, attrs = {})
      read_audio_properties_fields(file, attrs) do |opts|
        file.audio_properties.send opts[:method]
      end
    end

    def get_field(type, value, default = nil)
      case type
        when :string  then get_string_field value, default
        when :integer then get_integer_field value
        when :boolean then get_boolean_field value
        when :pair    then get_pair_field value
        when :image   then get_image_field value
      end
    end

    def get_string_field(value, default = nil)
      string = value && value.to_string_list.first
      if default.present? # then cast to integer (or use default if impossible)
        string ? string.to_i : default
      else
        string
      end
    end

    def get_integer_field(value)
      integer = value && value.to_int
      integer == 0 ? nil : integer # Note: Because BPM = 0 is not valid
    end

    def get_boolean_field(value)
      value && value.to_bool
    end

    def get_pair_field(value)
      pair = value ? value.to_int_pair : [nil, nil]
      {number: pair[0], count: pair[1]}
    end

    def get_image_field(value)
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
      {data: data, mime_type: mime_type}
    end
  end
end