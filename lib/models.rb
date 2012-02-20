# encoding: UTF-8

# Contains information related to an album
class AlbumInfo
  attr_accessor :artist_name, :album_name, :score, :pub_date, :rdio_album, :url

  def initialize artist_name, album_name, score, pub_date, url
    @artist_name = artist_name
    @album_name = album_name
    @score = score
    @pub_date = pub_date
    @url = url
  end

  def to_s
    "#{@artist_name}: #{@album_name} (#{@score})"
  end
end
