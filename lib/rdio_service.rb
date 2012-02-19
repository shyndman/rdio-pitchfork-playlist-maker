# encoding: UTF-8

class RdioService

  RDIO_ACCESS_TOKEN = "#{PROJECT_ROOT}/.rdio_access_token"
  DATE_FORMAT = "%b %e, %Y"

  @is_initialized = false

  def self.is_initialized
    @is_initialized
  end

  def self.is_initialized= flag
    @is_initialized = flag
  end

  def initialize
    return if self.class.is_initialized

    token = Marshal.load File.new RDIO_ACCESS_TOKEN
    Rdio.init_with_token token
    self.class.is_initialized = true
  end

  def search_for_album album_info
    Rdio::Search.search "#{album_info.artist_name} #{album_info.album_name}", "Album"
  end

  def create_playlist albums, missing_albums, since
    name = generate_playlist_name since
    description = generate_playlist_description albums, missing_albums
    tracks = albums.inject([]) do |tracks, album_info|
      tracks + clean_track_keys(album_info.rdio_album.track_keys)
    end

    Rdio::Playlist.create name, description, tracks
  end

  private

  def generate_playlist_name from, to = Time.now
    "ʕ•̫͡•ʔ Pitchfork Reviews - #{from.strftime(DATE_FORMAT)} to #{to.strftime(DATE_FORMAT)}"
  end

  def generate_playlist_description albums, missing_albums
    description = ""

    albums.each do |album_info|
      description << "#{album_info}\n"
    end

    return description if missing_albums.empty?

    description << "\n"
    description << "Albums not available on Rdio:\n"
    missing_albums.each do |album_info|
      description << "#{album_info}\n"
    end

    description
  end

  # XXX: Not sure why this is required. For some reason the JSON parser
  # mis-reads the track strings coming back from Rdio
  def clean_track_keys track_keys
    track_keys.map do |key|
      /t\d+/.match(key)[0]
    end
  end
end

# Searches for each of the provided albums on Rdio, filling out the
# AlbumInfo.rdio_album attribute if found.
def decorate_with_rdio_info albums
  puts "\nSearching Rdio for #{albums.size} albums"
  service = RdioService.new

  albums.each do |album_info|
    puts "  Searching Rdio for #{album_info.artist_name}: #{album_info.album_name}"
    results = service.search_for_album(album_info)

    next if results.nil?
    next if results.empty?

    album_info.rdio_album = results.first
  end
end

# Creates an Rdio playlist based on the provided album information
def create_rdio_playlist albums, missing_albums, since
  RdioService.new.create_playlist albums, missing_albums, since
end