$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler/setup"
require "open-uri"
require "nokogiri"
require "rdio"
require "launchy"
require "oauth"
require "ap"

require "lib/config"
require "lib/models"
require "lib/pitchfork"
require "lib/filters"
require "lib/rdio_service"


CONFIG_FILE = "config.yml"
PAGE_RANGE = 1..1
SCORE_RANGE = 5.0..10.0


# Make sure we have the files we need to
perform_startup_check

# Scrape the albums from Pitchfork
albums = get_albums_from_pages PAGE_RANGE

# Filter them by score
albums = filter_by_score albums, SCORE_RANGE

# Associate them with Rdio information
decorate_with_rdio_info albums

# Filter them by Rdio availability
albums, missing_albums = filter_by_rdio_availability albums

# Create a new playlist


# Create the Rdio playlist
ap albums