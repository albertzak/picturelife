module Picturelife

  class << self
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_reader :redirect_uri

    def redirect_uri=(uri)
      @redirect_uri = escape_uri(uri)
    end

    def authorization_uri
      [
        "https://api.picturelife.com/oauth/authorize?",
        "client_id=#{@client_id}",
        "&client_secret=#{@client_secret}",
        "&redirect_uri=#{@redirect_uri}",
        "&response_type=code"
      ].join
    end

    private

    def escape_uri(text)
      text.gsub(/[^a-zA-Z0-9\-\.\_\~]/) do |special|
        special.unpack('C*').map{ |i| sprintf('%%%02X', i) }.join
      end
    end
  end

end
