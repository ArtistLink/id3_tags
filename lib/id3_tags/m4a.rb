require 'id3_tags/m4a/fields'
require 'id3_tags/fields_accessors'
require 'id3_tags/m4a/fields_setter'
require 'id3_tags/m4a/fields_getter'

module Id3Tags
  class M4A
    include Id3Tags::M4AFields
    include Id3Tags::FieldsAccessors
    include Id3Tags::M4AFieldsGetter
    include Id3Tags::M4AFieldsSetter

    def read_tags_from(file_path)
      attrs = {}
      TagLib::MP4::File.open(file_path) do |file|
        attrs.merge! get_tag_fields(file)
        attrs.merge! get_audio_properties_fields(file)
      end
      attrs.symbolize_keys
    end

    def write_tags_to(file_path, attrs = {})
      attrs.symbolize_keys!
      TagLib::MP4::File.open(file_path) do |file|
        set_tag_fields! file, attrs
        file.save
      end
    end
  end
end