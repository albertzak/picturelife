module Picturelife

  RULER_ENDPOINT = "https://services.picturelife.com/ruler"

  module Ruler

    def upload(file, force = false)
      needs_token!

      @file      = file 
      @signature = get_signature(file)
      @filename  = get_filename(file)
      @force     = force

      media_exists || perform_upload
    end

    private

    def media_exists
      medias = Picturelife::Medias.check_signatures(signatures: @signature)['signatures'] || {}
      return false if medias.empty?
      return medias[@signature]['media_id'] unless @force
      return false
    end

    def perform_upload

    end

    def filesize_completed
      ruler do |r|
        r.head(query)['X-Ruler-Size'] || 0
      end
    end

    def query
      "?signature=#{@signature}&filename=#{@filename}"
    end


    def ruler(&block)
      Net::HTTPS.start(URI(RULER_ENDPOINT), 433) do |request|
        request['Authorization'] = "Bearer #{Picturelife.access_token}"
        yield request
      end
    end

  end
end
