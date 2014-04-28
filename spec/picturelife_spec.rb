require 'spec_helper'

describe Picturelife do
  before(:each) do
    Picturelife.client_id     = 'aaa'
    Picturelife.client_secret = 'bbb'
    Picturelife.redirect_uri  = 'ccc'
  end

  it 'accepts api keys' do
    expect { Picturelife.client_id     = 'test' }.not_to raise_error
    expect { Picturelife.client_secret = 'test' }.not_to raise_error
    expect { Picturelife.redirect_uri  = 'test' }.not_to raise_error
  end

  it 'escapes redirect uri' do
    Picturelife.redirect_uri = 'http://localhost:4567/?code=a'
    expect(Picturelife.redirect_uri).to eq 'http%3A%2F%2Flocalhost%3A4567%2F%3Fcode%3Da'
  end

  it 'builds valid authorization url' do
    expect(Picturelife.authorization_uri).to include 'aaa'
    expect(Picturelife.authorization_uri).to include 'bbb'
    expect(Picturelife.authorization_uri).to include 'ccc'
  end

  it 'returns access token' do
    Picturelife.stub(:access_token).and_return('code')
    expect(Picturelife.access_token('code')).to eq 'code'
  end

  it 'generated client uuid' do
    expect(Picturelife.send(:client_uuid)).to be_kind_of(String)
  end

  it 'caches uuid' do
    uuid = Proc.new { Picturelife.send(:client_uuid) } 
    expect(uuid).to eq uuid
  end

  it 'queries API' do
    expect(Net::HTTP).to receive(:get) do |uri|
      expect(uri.scheme).to eq 'https'
      expect(uri.query).to include 'client_id=aaa'
      expect(uri.query).to include 'client_secret=bbb'
      expect(uri.query).to include 'code=code'
      expect(uri.to_s).to include Picturelife::OAUTH_ENDPOINT
    end.and_return('{"access_token"=>"ddd"}')

    Picturelife.access_token('code')
  end

  it 'API returns hashrocket that is converted to json' do
    Net::HTTP.stub(:get).and_return('{"access_token"=>"ddd"}')
    expect(Picturelife.access_token('code')).to eq 'ddd'
  end

  it 'stubs missing constant names' do
    expect { Picturelife::SmartFilters }.not_to raise_error
  end

  it 'stubs missing methods on missing constants' do
    expect { Picturelife::SmartFilters.index }.not_to raise_error
  end

  it 'stubs call correct api method' do
    expect(Picturelife::Api).to receive(:call).with('smart_filters/index', nil)
    Picturelife::SmartFilters.index
  end

  it 'stubs call correct api method with args' do
    expect(Picturelife::Api).to receive(:call).with('smart_filters/index', { include_system: true })
    Picturelife::SmartFilters.index({ include_system: true })
  end

end
