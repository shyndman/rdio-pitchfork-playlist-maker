# encoding: UTF-8

require "date"

CONFIG_FILE_PATH = "#{PROJECT_ROOT}/config/config.yml"
MISSING_ALBUMS_FILE_PATH = "#{PROJECT_ROOT}/missing_albums.yml"
RDIO_ACCESS_TOKEN_PATH = "#{PROJECT_ROOT}/.rdio_access_token"
RDIO_API_HOME_PAGE = "http://developer.rdio.com/"
ONE_WEEK_IN_DAYS = 7


# Makes sure all required files exist
def perform_startup_check
  unless File.exists? CONFIG_FILE_PATH
    config_not_found
    exit 1
  end

  unless File.exists? RDIO_ACCESS_TOKEN_PATH
    access_token_not_found
  end
end

# Prints an error message, and launches the Rdio develop home page
def config_not_found
  puts "No configuration file found!\n" +
       "An Rdio API key is required to use this application.\n" +
       "Register for a key, make a copy of config.yml.sample called config.yml, " +
       "and fill it in with details provided by Rdio.\n\n" +
       "Press any key to open the Rdio developer page..."

  gets # Wait for keypress
  Launchy.open(RDIO_API_HOME_PAGE)
end

# Generates an authentication token
def access_token_not_found
  require "lib/create_rdio_access_token"

  config = load_config
  GenerateAccessToken.new(config["rdio_key"], config["rdio_secret"])

  puts "Access token generated...beginning playlist generation"
end

# Gets the last time we ran
def get_last_checkpoint
  load_config["last_checkpoint"] || (Date.today - ONE_WEEK_IN_DAYS)
end

# Saves the checkpoint to the configuration file
def save_checkpoint checkpoint
  config = load_config
  config["last_checkpoint"] = checkpoint
  save_config config
end

# Loads the missing albums file
def load_missing_albums
  unless File.exists? MISSING_ALBUMS_FILE_PATH
    return []
  end

  YAML::load(open(MISSING_ALBUMS_FILE_PATH))
end

# Saves the albums not found on Rdio
def save_missing_albums missing_albums
  # Nil out all the Rdio albums, because we don't want them to be serialized
  missing_albums.each do |album_info|
    album_info.rdio_album = nil
  end

  File.open(MISSING_ALBUMS_FILE_PATH, "w") { |file| file.puts(missing_albums.to_yaml) }
end

# Loads, parses and returns the config.yml file
def load_config
  YAML::load(open(CONFIG_FILE_PATH))
end

# Saves the configuration file
def save_config config
  File.open(CONFIG_FILE_PATH, "w") { |file| file.puts(config.to_yaml) }
end