require 'taglib'
require 'active_support/core_ext/hash'

module Id3Tags
  module M4AFieldsSetter
  private
    def set_tag_fields!(file, attrs = {})
      with_fields(:tag).each do |field, opts|
        file.tag.item_list_map.erase opts[:frame_id]
        frame = new_frame_for attrs[field], opts[:frame_id], opts[:type]
        file.tag.item_list_map.insert opts[:frame_id], frame if frame
      end unless file.tag.nil?
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
        return unless content[:number]
        pair = content.values_at :number, :count
        TagLib::MP4::Item.from_int_pair int_pair_for(pair)
      when :image
        return unless content[:data]
        mime_type = case content[:mime_type]
          when 'image/jpeg' then TagLib::MP4::CoverArt::JPEG
          when 'image/png' then TagLib::MP4::CoverArt::PNG
          else return # other formats unsupported by taglib-ruby
        end
        cover_art = TagLib::MP4::CoverArt.new mime_type, content[:data]
        TagLib::MP4::Item.from_cover_art_list [cover_art]
      end
    end

    # Return a *valid* int pair to build a TagLib::MP4::Item object
    #
    # @param [Array] pair an array of two elements
    # @return [Array] a valid pair to use in TagLib::MP4::Item.from_int_pair
    #
    # @example int_pair_for([1, 2)] #=> [1, 2]
    # @example int_pair_for([0, nil)] #=> [0, 0]
    #
    # @note This function helps writing tags with pairs that only have one
    #       value set. A common case is tracks with a *track number* and
    #       without a *track count*. This information is stored in M4A files
    #       by setting the *track count* to 0 (and not to 'nil').
    def int_pair_for(pair)
      pair.map{|n| n || 0}
    end
  end
end