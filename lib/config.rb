PROJECT_ROOT = File.expand_path("#{File.dirname(__FILE__)}/..")
CONFIG_FILE_PATH = "#{PROJECT_ROOT}/config.yml"
RDIO_ACCESS_TOKEN_PATH = "#{PROJECT_ROOT}/.rdio_access_token"
RDIO_API_HOME_PAGE = "http://developer.rdio.com/"


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

# Loads, parses and returns the config.yml file
def load_config
  YAML::load(open(CONFIG_FILE))
end