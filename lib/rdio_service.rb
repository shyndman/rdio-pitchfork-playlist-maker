class RdioService

  RDIO_ACCESS_TOKEN = ".rdio_access_token"

  def initialize
    token = Marshal.load File.new RDIO_ACCESS_TOKEN
  end

  def search_for_album album_info
    Search.search "#{album_info.artist} #{album_info.album_name}", "Album"
  end
end

# Searches for each of the provided albums on Rdio, filling out the
# AlbumInfo.rdio_album attribute if found.
def decorate_with_rdio_info albums
  service = RdioService.new

  albums.each do |album_info|
    album_info.rdio_album = service.search_for_album(album_info)
  end
end