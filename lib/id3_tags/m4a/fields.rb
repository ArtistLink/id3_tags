# coding: utf-8
module Id3Tags
  module M4AFields
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
  end
end