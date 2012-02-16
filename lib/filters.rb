def filter_by_score albums, min_score
  albums.select do |album_info|
    album_info.score >= min_score
  end
end

def filter_by_availability albums
  albums
end