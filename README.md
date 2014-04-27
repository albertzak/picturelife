# Picturelife

## Installation

Add this line to your application's Gemfile:

    gem 'picturelife'

And then execute:

    $ bundle

## Features

  - Minimal dependencies
  - Authentication via OAuth
  - Resumable photo upload

## Usage

```ruby

    require 'picturelife'

    Picturelife.client_id     = ENV['CLIENT_ID']
    Picturelife.client_secret = ENV['CLIENT_SECRET']

```
