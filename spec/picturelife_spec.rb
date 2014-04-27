require 'spec_helper'

describe Picturelife do
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
    Picturelife.client_id     = 'aaa'
    Picturelife.client_secret = 'bbb'
    Picturelife.redirect_uri  = 'ccc'

    expect(Picturelife.authorization_uri).to include 'aaa'
    expect(Picturelife.authorization_uri).to include 'bbb'
    expect(Picturelife.authorization_uri).to include 'ccc'
  end

end
