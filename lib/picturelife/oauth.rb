module Picturelife

  OAUTH_ENDPOINT = "https://api.picturelife.com/oauth/"

  class << self
    def authorization_uri
      needs_configuration!

      [
        OAUTH_ENDPOINT,
        "authorize?",
        "client_id=#{@client_id}",
        "&client_secret=#{@client_secret}",
        "&redirect_uri=#{@redirect_uri}",
        "&response_type=code"
      ].join
    end

    def access_token=(code)
      needs_configuration!

      uri = [
        OAUTH_ENDPOINT,
        "access_token?",
        "client_id=#{@client_id}",
        "&client_secret=#{@client_secret}",
        "&code=#{code}",
        "&client_uuid=#{client_uuid}"
      ].join

      @access_token = api_oauth_get(uri)['access_token']
    end

    private
    
    def api_oauth_get(uri)
      uri      = URI(URI.encode(uri))
      response = Net::HTTP.get(uri)
      response = JSON.parse(hashrocket_to_json(response))
      raise OAuthError.new(response["error"]) if response["status"] != 200
      response
    end

  end
end
