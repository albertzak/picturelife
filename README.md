# Picturelife

## Installation

Add this line to your application's Gemfile:

    gem 'picturelife'

And then execute:

    $ bundle

## Features

  - Resumable photo upload
  - Authentication via OAuth
  - Minimal dependencies
  - Ruby syntax

## Usage

### Setup
```ruby

    require 'picturelife'

    Picturelife.client_id     = ENV['CLIENT_ID']
    Picturelife.client_secret = ENV['CLIENT_SECRET']

    Picturelife.redirect_uri  = 'http://localhost:3000/oauth'

```

### Authorization

```ruby

      <a href="<%= Picturelife.authorization_uri %>">Click here</a> to connect to Picturelife!</a>

```

```ruby

    get '/oauth' do
      code = params['code']
      Picturelife.access_token = code
    end

```

```ruby
    
    Picturelife::Medias.index(limit: 10)


```


