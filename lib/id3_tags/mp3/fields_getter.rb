require 'taglib'
require 'active_support/core_ext/hash'

module Id3Tags
  module MP3FieldsReader
  private
    def get_tag_fields(file, attrs = {})
      read_tag_fields(file, attrs) do |opts|
        file.tag.send opts[:method]
      end
    end

    def get_audio_properties_fields(file, attrs = {})
      read_audio_properties_fields(file, attrs) do |opts|
        file.audio_properties.send opts[:method]
      end
    end

    def get_id3v2_tag_fields(file, attrs = {})
      read_id3v2_tag_fields(file, attrs) do |opts|
        value = file.id3v2_tag.frame_list(opts[:frame_id]).first
        value and opts[:type] != :image ? value.to_string : value
      end
    end

    def get_field(type, value, default = nil)
      case type
        when :string  then get_string_field value
        when :text    then get_string_field value
        when :integer then get_integer_field value
        when :boolean then get_boolean_field value
        when :pair    then get_pair_field value
        when :image   then get_image_field value
      end
    end

    def get_string_field(value)
      value && value.to_s
    end

    def get_integer_field(value)
      value && value.to_i
    end

    def get_boolean_field(value)
      value.present? && value.eql?('1')
    end

    def get_pair_field(value)
      pair = value ? value.split('/').map(&:to_i) : [nil, nil]
      {number: pair[0], count: pair[1]}
    end

    def get_image_field(value)
      pair = [value && value.mime_type, value && value.picture]
      pair = pair.map(&:presence)
      {mime_type: pair[0], data: pair[1]}
    end
  end
end