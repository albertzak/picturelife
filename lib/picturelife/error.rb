module Picturelife

  class NotConfiguredError < StandardError
    def initialize
      super <<-MSG.gsub(/^ {6}/, '')

        You need to set up your API Credentials like this:
          Picturelife.client_id     = ENV['CLIENT_ID']
          Picturelife.client_secret = ENV['CLIENT_SECRET']
          Picturelife.redirect_uri  = 'http://localhost:3000/oauth'
      MSG
    end
  end

  class NotAuthenticatedError < StandardError
    def initialize
      super <<-MSG.gsub(/^ {6}/, '')

        Send your User to `Picturelife.authorization_uri` and catch
        the access token from your `Picturelife.redirect_uri` like so:
          Picturelife.access_token(params[:code])
      MSG
    end
  end

  class OAuthError < StandardError; end
  class ApiError < StandardError; end


  module Util

    def needs_configuration!
      raise NotConfiguredError unless Picturelife.configured?
    end

    def needs_token!
      needs_configuration!
      raise NotAuthenticatedError unless Picturelife.authenticated?
    end

  end

end
