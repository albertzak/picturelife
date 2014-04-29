# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'picturelife'

Gem::Specification.new do |spec|
  spec.name          = 'picturelife'
  spec.version       = Picturelife::VERSION
  spec.authors       = ['Albert Zak']
  spec.email         = ['me@albertzak.com']
  spec.summary       = %q{Picturelife API. OAuth. Resumable Uploads.}
  spec.description   = 'A gem to access the Picturelife API.'
  spec.homepage      = 'https://github.com/albertzak/picturelife'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'json'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-nc'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-remote'
  spec.add_development_dependency 'pry-nav'
end
