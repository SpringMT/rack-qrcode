require 'spec_helper'
require 'application_helper'
require 'rack/test'

describe Rack::Qrcode do
  include Rack::Test::Methods
  
  let(:app) {Rack::Qrcode.new(ApplicationHelper::Application.new())}

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
    expect(last_response.status).to eq 200
  end

end
