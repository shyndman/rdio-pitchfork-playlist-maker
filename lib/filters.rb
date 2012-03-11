# encoding: UTF-8

def filter_by_pub_date albums, since
  albums.select do |album_info|
    album_info.pub_date > since
  end
end

def filter_by_score albums, score_range
  puts "\nFiltering by score - accepted range: #{score_range}"

  albums.select do |album_info|
    unless score_range.include? album_info.score
      puts "  Filtering #{album_info} - score out of range"
      next false
    end

    true
  end
end

def filter_by_rdio_availability albums
  puts "\nFiltering by Rdio availability"

  separated_albums = { :found => [], :missing => [] }

  albums.each do |album_info|
    if album_info.rdio_album.nil? or !album_info.rdio_album.can_stream
      puts "  Filtering #{album_info} - not yet available on Rdio"
      separated_albums[:missing] << album_info
    else
      separated_albums[:found] << album_info
    end
  end

  [separated_albums[:found], separated_albums[:missing]]
end