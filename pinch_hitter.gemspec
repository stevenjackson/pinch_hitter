# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pinch_hitter/version'

Gem::Specification.new do |gem|
  gem.name          = "pinch_hitter"
  gem.version       = PinchHitter::VERSION
  gem.authors       = ["Steve Jackson"]
  gem.email         = ["steve.jackson@leandogsoftware.com"]
  gem.description   = %q{A simple web service that returns primed responses in FIFO order}
  gem.summary       = %q{Test utility for mocking out external web responses}
  gem.homepage      = "https://github.com/stevenjackson/pinch_hitter"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'sinatra', '>= 1.3.3'
  gem.add_dependency 'nokogiri', '>= 1.5.6'
  gem.add_dependency 'json', '>= 1.7.6'
  gem.add_dependency 'sinatra-cross_origin', '~> 0.3.1'

  gem.add_development_dependency 'minitest', '>= 4.3.3'
  gem.add_development_dependency 'rack-test', '>= 0.6.2'
  gem.add_development_dependency 'rake', '>= 10.0.3'
  gem.add_development_dependency 'rspec', '>= 2.12.0'
  gem.add_development_dependency 'cucumber', '>= 1.2.1'
end
