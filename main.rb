$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler/setup"
require "open-uri"
require "nokogiri"
require "rdio"
require "ap"

require "lib/models"
require "lib/pitchfork_scrape"
require "lib/filters"
require "lib/rdio_service"


CONFIG_FILE = "config.yml"
PAGE_RANGE = 1..1
MINIMUM_SCORE = 5.0


# Loads, parses and returns the config.yml file
def load_config
  YAML::load(open(CONFIG_FILE))
end

# Scrape the albums from Pitchfork
albums = get_albums_from_pages PAGE_RANGE

# Filter them by score
albums = filter_by_score albums, MINIMUM_SCORE

# Associate them with Rdio information
decorate_with_rdio_info albums

# Filter them by Rdio availability
albums = filter_by_rdio_availability albums

# Create the Rdio playlist
ap albums