module Picturelife
  class << self
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_reader :redirect_uri
    attr_reader :access_token

    def redirect_uri=(uri)
      @redirect_uri = escape_uri(uri)
    end

    def configured?
      Picturelife.client_id     &&
      Picturelife.client_secret &&
      Picturelife.redirect_uri
    end

    def authenticated?
      Picturelife.access_token
    end

    def reset_configuration!
      Picturelife.client_id     = nil
      Picturelife.client_secret = nil
      Picturelife.redirect_uri  = nil
    end

    def reset_authentication!
      @access_token = nil
    end
  end
end
