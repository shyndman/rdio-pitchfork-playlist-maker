PITCHFORK_BASE_URL = "http://pitchfork.com"
PITCHFORK_INDEX_URL_FORMAT = "#{PITCHFORK_BASE_URL}/reviews/albums/%d/"

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
    memo << parse_album_page("#{PITCHFORK_BASE_URL}#{album_link.attr("href")}")

    puts "Scraped... #{memo.last}"
    sleep 0.2

    memo
  end
end

def get_albums_from_pages page_range
  albums = []
  page_range.each do |pg|
    albums += parse_index_page(PITCHFORK_INDEX_URL_FORMAT % pg)
  end

  albums
end