module Id3Tags
  module MP3Fields
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
  end
end