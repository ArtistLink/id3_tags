require 'id3_tags/mp3/fields'
require 'id3_tags/fields_accessors'
require 'id3_tags/mp3/fields_setter'
require 'id3_tags/mp3/fields_getter'

module Id3Tags
  class MPEG
    include Id3Tags::MP3Fields
    include Id3Tags::FieldsAccessors
    include Id3Tags::MP3FieldsReader
    include Id3Tags::MP3FieldsWriter

    def read_tags_from(file_path)
      attrs = {}
      TagLib::MPEG::File.open(file_path) do |file|
        attrs.merge! get_tag_fields(file)
        attrs.merge! get_audio_properties_fields(file)
        attrs.merge! get_id3v2_tag_fields(file)
      end
      attrs.symbolize_keys
    end

    def write_tags_to(file_path, attrs = {})
      attrs.symbolize_keys!
      TagLib::MPEG::File.open(file_path) do |file|
        set_tag_fields!(file, attrs)
        set_id3v2_tag_fields!(file, attrs)
        file.save
      end
    end
  end
end