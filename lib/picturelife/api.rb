module Picturelife

  API_ENDPOINT = "https://api.picturelife.com/"

  class Api
    class << self

      def call(uri, args = nil)
        needs_token!

        build_uri(uri, args)
      end

      private

      def build_uri(uri, args = nil)
        [API_ENDPOINT, uri, build_parameters(args)].join
      end

      def build_parameters(args = {})
        return '' if args.nil?
        return ['?', args].join if args.is_a? String
        return ['?', URI.encode_www_form(args)].join
      end

    end
  end
end
