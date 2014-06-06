module Picturelife
  class << self
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :access_token
    attr_accessor :refresh_token
    attr_reader   :redirect_uri
    attr_reader   :token_expires
    attr_reader   :user_id

    def redirect_uri=(uri)
      @redirect_uri = escape_uri(uri)
    end

    def configured?
      @client_id     &&
      @client_secret &&
      @redirect_uri
    end

    def authenticated?
      !! @access_token
    end

    def reset_configuration!
      @client_id     = nil
      @client_secret = nil
      @redirect_uri  = nil
      reset_authentication!
    end

    def reset_authentication!
      @access_token  = nil
      @refresh_token = nil
      @token_expires = nil
      @user_id       = nil
    end
  end
end
