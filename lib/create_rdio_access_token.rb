# encoding: UTF-8

# Creates an Rdio access token based on the provided API key and secret.
#
class GenerateAccessToken

  RDIO_API_BASE_URL = "http://api.rdio.com"

  def initialize key, secret
    token = access_token key, secret
    f = File.open ".rdio_access_token", "w"
    data = Marshal.dump token, f
  end

  private

  # Returns the access token
  def access_token key, secret
    consumer = OAuth::Consumer.new key, secret,
      :site => RDIO_API_BASE_URL,
      :request_token_path => "/oauth/request_token",
      :authorize_path => "/oauth/authorize",
      :access_token_path => "/oauth/access_token",
      :http_method => :post

    consumer.http.read_timeout = 600
    request_token = consumer.get_request_token :oauth_callback => "oob"
    url = "https://www.rdio.com/oauth/authorize?oauth_token=#{request_token.token.to_s}"
    oauth_verifier = get_pin url

    return request_token.get_access_token :oauth_verifier => oauth_verifier
  end

  # Gets the pin from the user
  def get_pin(url)
    # Opens the PIN page
    Launchy.open url

    #
    # Get the pin from the user
    #
    oauth_verifier = nil
    while not oauth_verifier or oauth_verifier == ""
      print "Enter the 4-digit PIN> "
      STDOUT.flush
      oauth_verifier = gets.strip
    end
    return oauth_verifier
  end
end
