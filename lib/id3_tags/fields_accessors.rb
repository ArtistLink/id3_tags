module Id3Tags
  module FieldsAccessors
  private
    def with_fields(type)
      fields.select{|k,v| v[:on] == type}
    end

    def read_tag_fields(file, attrs = {}, &block)
      with_fields(:tag).each do |field, opts|
        value = yield(opts)
        attrs[field] = get_field opts[:type], value, opts[:default]
      end unless file.tag.nil?
      attrs
    end

    def read_audio_properties_fields(file, attrs = {}, &block)
      with_fields(:audio_properties).each do |field, opts|
        value = yield(opts)
        attrs[field] = get_field :integer, value
      end unless file.audio_properties.nil?
      attrs
    end

    def read_id3v2_tag_fields(file, attrs = {}, &block)
      with_fields(:id3v2_tag).each do |field, opts|
        value = yield(opts)
        attrs[field] = get_field opts[:type], value
      end unless file.id3v2_tag.nil?
      attrs
    end
  end
end