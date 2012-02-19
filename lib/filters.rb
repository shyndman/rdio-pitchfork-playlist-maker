def filter_by_score albums, score_range
  albums.select do |album_info|
    score_range.include? album_info.score
  end
end

def filter_by_rdio_availability albums
  separated_albums = { :found => [], :missing => [] }

  albums.each do |album_info|
    if album_info.rdio_album.nil? or !album_info.rdio_album.can_stream
      separated_albums[:missing] << album_info
    else
      separated_albums[:found] << album_info
    end
  end

  [separated_albums[:found], separated_albums[:missing]]
end