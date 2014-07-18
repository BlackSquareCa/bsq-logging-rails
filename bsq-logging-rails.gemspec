# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'bsq-logging-rails/version'

Gem::Specification.new do |s|
  s.name        = 'bsq-logging-rails'
  s.version     = BlackSquareLoggingRails::VERSION
  s.authors     = ['William Richards']
  s.email       = ['techops@blacksquare.ca']
  s.homepage    = 'https://github.com/BlackSquareCa/bsq-logging-rails'
  s.summary     = %q{Implements BlackSquare's patterns and practices for logging from Rails applications}
  s.description = %q{Implements BlackSquare's patterns and practices for logging from Rails applications}

  # s.rubyforge_project = "lograge"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  # specify any dependencies here; for example:
  # s.add_development_dependency 'rspec'
  # s.add_development_dependency 'guard-rspec'
  s.add_runtime_dependency 'activesupport', '>= 3'
  s.add_runtime_dependency 'actionpack', '>= 3'
  s.add_runtime_dependency 'railties', '>= 3'
  s.add_runtime_dependency 'lograge', '>= 0.3.0'
  s.add_runtime_dependency 'scrolls', '>= 0.3.8'
end