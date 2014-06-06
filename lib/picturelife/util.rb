module Picturelife
  module Util

    def escape_uri(text)
      return '' if text.nil?
      CGI::escape(text)
    end

    def underscore(camelcase)
      camelcase.gsub(/(.)([A-Z])/,'\1_\2').downcase
    end

    def api_get(uri)
      uri = URI(URI.encode(uri))
      JSON.parse(Net::HTTP.get(uri))
    end

    def hashrocket_to_json(string)
      string.gsub('=>', ':')
    end

    def client_uuid
      @client_uuid ||= rand(10**10).to_s
    end

    def get_signature(file_path)
      Digest::SHA256.hexdigest File.read(file_path)
    end

    def get_filename(file_path)
      [get_signature(file_path), '_', client_uuid, File.extname(file_path)].join
    end

  end
end
