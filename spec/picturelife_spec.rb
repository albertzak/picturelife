require 'spec_helper'

describe Picturelife do
  before(:each) do
    Picturelife.client_id     = 'aaa'
    Picturelife.client_secret = 'bbb'
    Picturelife.redirect_uri  = 'ccc'

    Net::HTTP.stub(:get).and_return('{"status":20000}')
  end

  it 'accepts api keys' do
    expect { Picturelife.client_id     = 'test' }.not_to raise_error
    expect { Picturelife.client_secret = 'test' }.not_to raise_error
    expect { Picturelife.redirect_uri  = 'test' }.not_to raise_error
  end

  it 'raises error if not configured' do
    Picturelife.reset_configuration!
    expect { Picturelife.authorization_uri }. to raise_error(Picturelife::NotConfiguredError)
  end

  it 'raises error if not authenticated' do
    Picturelife.reset_authentication!
    expect { Picturelife::Api.call('/') }. to raise_error(Picturelife::NotAuthenticatedError)
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

  it 'gets and sets access token' do
    Net::HTTP.stub(:get).and_return('{"access_token":"token"}')

    Picturelife.access_token = 'code'
    expect(Picturelife.access_token).to eq 'token'
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

    Picturelife.access_token = 'code'
  end

  it 'API returns hashrocket that is converted to json' do
    parsable = hashrocket_to_json('{"access_token"=>"ddd"}')
    expect { JSON.parse(parsable) }.not_to raise_error
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

  it 'stubs call correct api method with argument' do
    expect(Picturelife::Api).to receive(:call).with('smart_filters/index', include_system: true)
    Picturelife::SmartFilters.index(include_system: true)
  end

  it 'stubs call correct api method with multiple args' do
    expect(Picturelife::Api).to receive(:call).with('smart_filters/index', { include_system: true, limit: 10 })
    Picturelife::SmartFilters.index({ include_system: true, limit: 10 })
  end

  it 'builds url parameters without args' do
    url = Picturelife::Api.send(:build_uri, 'smart_filters/index')
    expect(url).to eq 'https://api.picturelife.com/smart_filters/index'
  end

  it 'builds url parameters from args' do
    url = Picturelife::Api.send(:build_uri, 'smart_filters/index', {limit: 10})
    expect(url).to eq 'https://api.picturelife.com/smart_filters/index?limit=10'
  end

  it 'builds url parameters from multiple args' do
    url = Picturelife::Api.send(:build_uri, 'smart_filters/index', {limit: 10, include_system: true})
    expect(url).to eq 'https://api.picturelife.com/smart_filters/index?limit=10&include_system=true'
  end

  it 'builds url parameters from string' do
    url = Picturelife::Api.send(:build_uri, 'smart_filters/index', 'limit=10&include_system=true')
    expect(url).to eq 'https://api.picturelife.com/smart_filters/index?limit=10&include_system=true'
  end

end
