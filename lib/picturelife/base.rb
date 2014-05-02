module Picturelife
  class << self
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :access_token
    attr_reader :redirect_uri

    def redirect_uri=(uri)
      @redirect_uri = escape_uri(uri)
    end

    def configured?
      @client_id     &&
      @client_secret &&
      @redirect_uri
    end

    def authenticated?
      @access_token
    end

    def reset_configuration!
      @client_id     = nil
      @client_secret = nil
      @redirect_uri  = nil
    end

    def reset_authentication!
      @access_token = nil
    end
  end
end
