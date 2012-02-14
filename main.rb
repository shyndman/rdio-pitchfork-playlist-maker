require "rubygems"
require "bundler/setup"
require "open-uri"
require "nokogiri"
require "ap"

NUM_PAGES = 1
MINIMUM_SCORE = 5.0
PITCHFORK_BASE_URL = "http://pitchfork.com"
PITCHFORK_INDEX_URL_FORMAT = "#{PITCHFORK_BASE_URL}/reviews/albums/%d/"

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

def parse_album_page url
  doc = Nokogiri::HTML(open(url))
  artist_name = doc.css(".review-meta .info h1").first.text
  album_name = doc.css(".review-meta .info h2").first.text
  score = doc.css(".score").text().strip.to_f

  AlbumInfo.new artist_name, album_name, score
end

def parse_index_page url
  doc = Nokogiri::HTML(open(url))
  doc.css(".object-grid a").inject([]) do |memo, album_link|
    album = parse_album_page("#{PITCHFORK_BASE_URL}#{album_link.attr("href")}")

    puts "Processing... #{album}"

    if album.score >= MINIMUM_SCORE
      puts "  Including"
      memo << album
    else
      puts "  Filtering"
    end

    memo
  end
end

#
# Do it!
#

albums = []

(1..NUM_PAGES).each do |pg|
  albums += parse_index_page(PITCHFORK_INDEX_URL_FORMAT % pg)
end

ap albums