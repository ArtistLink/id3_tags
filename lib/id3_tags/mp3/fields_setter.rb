require 'taglib'
require 'active_support/core_ext/hash'

module Id3Tags
  module MP3FieldsWriter
  private
    def set_tag_fields!(file, attrs = {})
      with_fields(:tag).each do |field, opts|
        file.tag.send "#{opts[:method]}=", (attrs[field] || opts[:default])
      end unless file.tag.nil?
    end

    def set_id3v2_tag_fields!(file, attrs = {})
      with_fields(:id3v2_tag).each do |field, opts|
        file.id3v2_tag.remove_frames opts[:frame_id]
        frame = new_frame_for opts[:type], attrs[field], opts[:frame_id]
        file.id3v2_tag.add_frame frame if frame
      end unless file.id3v2_tag.nil?
    end

    def new_frame_for(type, content, frame_id)
      case type
        when :string  then new_frame_for_string  content, frame_id
        when :integer then new_frame_for_string  content, frame_id
        when :text    then new_frame_for_text    content, frame_id
        when :boolean then new_frame_for_boolean content, frame_id
        when :pair    then new_frame_for_pair    content, frame_id
        when :image   then new_frame_for_image   content, frame_id
      end unless content.nil?
    end

    def new_frame_for_string(content, frame_id)
      new_string_frame(frame_id).tap {|frame| frame.text = content.to_s}
    end

    def new_frame_for_text(content, frame_id)
      new_text_frame(frame_id).tap {|frame| frame.text = content.to_s}
    end

    def new_frame_for_boolean(content, frame_id)
      return unless content.eql?(true)
      new_string_frame(frame_id).tap {|frame| frame.text = '1'}
    end

    def new_frame_for_pair(content, frame_id)
      return unless content.has_key? :number
      new_string_frame(frame_id).tap do |frame|
        frame.text = content.values_at(:number, :count).compact.join '/'
      end
    end

    def new_frame_for_image(content, frame_id)
      return unless content.has_key? :data
      new_image_frame(frame_id).tap do |frame|
        frame.description = 'Cover'
        frame.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
        frame.mime_type = content[:mime_type]
        frame.picture = content[:data]
      end
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