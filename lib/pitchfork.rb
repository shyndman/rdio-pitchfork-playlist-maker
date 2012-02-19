# encoding: UTF-8

require "date"

PITCHFORK_BASE_URL = "http://pitchfork.com"
PITCHFORK_INDEX_URL_FORMAT = "#{PITCHFORK_BASE_URL}/reviews/albums/%d/"
PAGE_RANGE = 1..2

# Parses out album information from a Pitchfork album review page
def parse_album_page url
  doc = Nokogiri::HTML(open(url))
  artist_name = doc.css(".review-meta .info h1").first.text
  album_name = doc.css(".review-meta .info h2").first.text
  score = doc.css(".score").text().strip.to_f
  pub_date = Date.parse(doc.css(".pub-date").text())

  AlbumInfo.new artist_name, album_name, score, pub_date
end

# Parses out a page of album review links, calling parse_album_page internally
# for each link found. An Array of AlbumInfos is returned.
def parse_index_page url
  doc = Nokogiri::HTML(open(url))
  doc.css(".object-grid a").inject([]) do |memo, album_link|
    memo << parse_album_page("#{PITCHFORK_BASE_URL}#{album_link.attr("href")}")

    puts "  Scraped #{memo.last}"
    sleep 0.2

    memo
  end
end

def get_albums_since since_time
  puts "Finding albums on Pitchfork reviewed since #{since_time}"

  albums = []

  PAGE_RANGE.each do |pg|
    albums += parse_index_page(PITCHFORK_INDEX_URL_FORMAT % pg)

    break if !albums.last.nil? and albums.last.pub_date < since_time
  end

  # If we scraped too far, do not include the album
  filter_by_pub_date albums, since_time
end