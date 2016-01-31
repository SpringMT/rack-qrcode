require 'spec_helper'
require 'pry'
require 'rack/test'

module ApplicationHelper
  extend self
  class Application
    def call(env)
      code   = 200
      body   = [ "test body" ]
      header = { "Content-Type"           => "text/html;charset=utf-8",
                 "Content-Length"         => "9",
                 "X-XSS-Protection"       => "1; mode=block",
                 "X-Content-Type-Options" => "nosniff",
                 "X-Frame-Options"        => "SAMEORIGIN" }
      [ code, header, body ]
    end
  end
end

describe Rack::Qrcode do
  include ApplicationHelper
  include Rack::Test::Methods

  let(:app) { Rack::Qrcode.new(ApplicationHelper::Application.new()) }

  it 'has a version number' do
    expect(Rack::Qrcode::VERSION).not_to be nil
  end

  it 'return a valid qrcode' do
    get '/qrcode', {
      text:  'test qrcode',
      width:  40,
      height: 40,
      size:   8,
      level:  :h
    }
    expect(last_response['Content-Type']).to eq 'image/png'
    expect(last_response['Content-Length'].to_i).to be > 0
    expect(last_response.status).to eq 200
  end

end
