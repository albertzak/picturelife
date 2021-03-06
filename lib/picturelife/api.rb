module Picturelife

  API_ENDPOINT = "https://api.picturelife.com/"

  class Api
    class << self

      def call(uri, args = nil)
        needs_token!

        api_get(build_uri(uri, args))
      end

      private

      def build_uri(uri, args = nil)
        [API_ENDPOINT, uri, build_parameters(args)].join
      end

      def build_parameters(args = nil)
        args = {} if args.nil?

        args.merge!(access_token: Picturelife.access_token)

        return ['?', URI.encode_www_form(args)].join
      end

      def api_get(uri)
        uri      = URI(URI.encode(uri))
        response = Net::HTTP.get(uri)
        response = parse_response(response)
        raise ApiError.new(response["status"], response["error"], response) if (response["status"] != 20000 && response["status"] != 200)
        response
      end

      def parse_response(string)
        error_response = {
          'status' => -1,
          'error'  => string.to_s
        }

        JSON.parse(response) rescue error_response
      end

    end
  end
end
