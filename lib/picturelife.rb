require 'json'
require 'net/https'
require 'digest/sha2'
require 'picturelife/error'
require 'picturelife/util'
require 'picturelife/base'
require 'picturelife/stub'
require 'picturelife/oauth'
require 'picturelife/api'
require 'picturelife/ruler'

include Picturelife::Util
include Picturelife::Ruler

module Picturelife
  VERSION = "0.0.1"
end
