module Picturelife

  OAUTH_ENDPOINT = "https://api.picturelife.com/oauth/"

  class << self
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_reader :redirect_uri

    def redirect_uri=(uri)
      @redirect_uri = escape_uri(uri)
    end

    def authorization_uri
      [
        OAUTH_ENDPOINT,
        "authorize?",
        "client_id=#{@client_id}",
        "&client_secret=#{@client_secret}",
        "&redirect_uri=#{@redirect_uri}",
        "&response_type=code"
      ].join
    end

    def access_token(code)
      uri = [
        OAUTH_ENDPOINT,
        "access_token?",
        "client_id=#{@client_id}",
        "&client_secret=#{@client_secret}",
        "&code=#{code}",
        "&client_uuid=#{client_uuid}"
      ].join

      api_get(uri)['access_token']
    end

  end

end
