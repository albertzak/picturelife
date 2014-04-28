module Picturelife
  module Util

    def escape_uri(text)
      CGI::escape(text)
    end

    def underscore(camelcase)
      camelcase.gsub(/(.)([A-Z])/,'\1_\2').downcase
    end

    def api_get(uri)
      uri = URI(URI.encode(uri))
      JSON.parse(hashrocket_to_json(Net::HTTP.get(uri)))
    end

    def hashrocket_to_json(string)
      string.gsub('=>', ':')
    end

    def client_uuid
      @client_uuid ||= rand(36**36).to_s(36)
    end

  end
end
