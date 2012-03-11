# encoding: UTF-8

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require "rubygems"
require "bundler/setup"
require "yaml"
require "open-uri"
require "nokogiri"
require "rdio"
require "launchy"
require "oauth"
require "ap"
require "twitter"


PROJECT_ROOT = File.expand_path(File.dirname(__FILE__))

require "lib/args"
require "lib/config"
require "lib/models"
require "lib/pitchfork"
require "lib/filters"
require "lib/rdio_service"

SCORE_RANGE = 4..10

# Parse arguments
args = parse_args

# Make sure we have the files we need to
perform_startup_check

# Get the checkpoint (determines what albums to include in playlist)
checkpoint = get_last_checkpoint

# Check whether we've run today
if Date.today == checkpoint
  puts "Exiting...already run today"
  exit 0
end

# Scrape the albums from Pitchfork
albums = get_albums_since checkpoint

# Filter them by score
albums = filter_by_score albums, SCORE_RANGE

# Associate them with Rdio information
decorate_with_rdio_info albums

# Filter them by Rdio availability
albums, missing_albums = filter_by_rdio_availability albums

unless args[:dry_run]

  # Create a new playlist
  create_rdio_playlist albums, missing_albums, checkpoint

  # Save checkpoint
  save_checkpoint Date.today

  # Save missing albums (to try and pick up later)
  save_missing_albums missing_albums
end
