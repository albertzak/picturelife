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

    def access_token_from_code=(code)
      needs_configuration!

      uri = [
        OAUTH_ENDPOINT,
        "access_token?",
        "client_id=#{@client_id}",
        "&client_secret=#{@client_secret}",
        "&code=#{code}",
        "&client_uuid=#{client_uuid}"
      ].join

      res = api_oauth_get(uri)

      if res['status'] != 200
        raise OAuthError.new(res['status'], res['error'], res)
      else
        @refresh_token = res['refresh_token']
        @user_id       = res['user_id']
        @token_expires = Time.at(res['expires'])
        @access_token  = res['access_token']        
      end
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
