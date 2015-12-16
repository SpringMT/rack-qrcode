require "rack/qrcode/version"
require 'rqrcode_png'
require "cgi"

module Rack
  class Qrcode
    def initialize(app, options = {})
      @app  = app
      @path = options[:path] || '/qrcode'
    end

    def call(env)
      return @app.call(env) unless env['PATH_INFO'] == @path

      params = CGI.parse(env["QUERY_STRING"])
      if params['text'].empty?
        return [400, {'Content-Type' => 'text/html'}, ["Bad Request"]]
      end
      text   = params['text'].first
      size   = params['size'].empty?  ?  4 : params['size'].first.to_i
      level  = params['level'].empty? ? :h : params['level'].first.to_sym
      width  = params['width'].empty?  ? 200 : params['width'].first.to_i
      height = params['height'].empty? ? 200 : params['height'].first.to_i
      qr  = RQRCode::QRCode.new(text, size: size, level: level)
      png = qr.to_img
      body = png.resize(width, height).to_blob
      headers = {
        "Content-Length" => body.bytesize.to_s,
        "Content-Type"   => "imgae/png",
        "Last-Modified"  => Time.now.httpdate
      }

      [200, headers, [body]]
    end
  end
end
