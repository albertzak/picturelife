module Picturelife

  RULER_ENDPOINT = "https://services.picturelife.com/ruler/"

  module Ruler

    def upload(file_path, options = {}, processing_needs = [])
      needs_token!

      @file_path        = file_path
      @signature        = get_signature(file_path)
      @filename         = get_filename(file_path)
      @force            = !! options[:force]
      @options          = options
      @processing_needs = processing_needs

      media_exists || perform_upload

    rescue RulerError => e
      (e.code == 519256) ? retry : raise(e)
    rescue Timeout::Error, Errno::ECONNRESET
      retry
    end

    def head(file_path)
      @file_path = file_path
      @signature = get_signature(file_path)
      @filename  = get_filename(file_path)

      ruler('HEAD')
    end

    private

    def media_exists
      medias = Picturelife::Medias.check_signatures(signatures: @signature)['signatures'] || {}
      return false if medias.empty?
      return Picturelife::Medias.show(media_id: medias[@signature]['media_id']) unless @force
      return false
    end

    def perform_upload      
      header   = { 'Content-Range'  => "bytes #{filesize_uploaded}-#{filesize_total}/#{filesize_total}" }
      location = ruler(:put, file_partial, header)['location']
      create_media_from_ruler(location)
    end

    def file_partial
      IO.binread(@file_path, nil, filesize_uploaded)
    end

    def filesize_total
      File.size(@file_path)
    end

    def filesize_uploaded
      @filesize_uploaded ||= lambda do
        uploaded = ruler(:head)['X-Ruler-Size']
        uploaded = uploaded.first if uploaded
        uploaded.to_i
      end.call
    end

    def create_media_from_ruler(location)
      Picturelife::Media.create({
        url: location,
        signature: @signature,
        force: (!!@force).to_s,
        local_path: @file_path,
        processing_needs: @processing_needs.map(&:to_s).join(',')
      }.merge(@options))
    end

    def auth
      { 
        'Authorization' => "Bearer #{Picturelife.access_token}",
        'User-Agent'    => "rubygem/#{VERSION}"
      }
    end

    def ruler(verb, data = nil, headers = {})
      http = Excon.new(RULER_ENDPOINT + @filename)
      res  = http.request(
        method:     verb,
        query:      { signature: @signature },
        headers:    auth.merge(headers),
        body:       data,
        idempotent: true
      )

      body = res.body
      body = (body && body.length >= 2) ? JSON.parse(body) : {}
      body.merge!(res.headers)

      unless body['X-Ruler-Error-Code'].to_s.empty?
        raise RulerError.new(body['X-Ruler-Error-Code'], body['X-Ruler-Error'], body)
      else
        body
      end
    end

  end
end
