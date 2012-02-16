# Contains information related to an album
class AlbumInfo
  attr :artist_name, :album_name, :score

  def initialize artist_name, album_name, score
    @artist_name = artist_name
    @album_name = album_name
    @score = score
  end

  def to_s
    "#{@artist_name}: #{@album_name} (#{@score})"
  end
end
