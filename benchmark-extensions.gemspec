# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bme/version'

Gem::Specification.new do |gem|
  gem.name          = 'benchmark-extensions'
  gem.version       = BME::VERSION
  gem.authors       = ['Lenny Marks']
  gem.email         = %w(lenny@aps.org)
  gem.description   = %q{Benchmark extensions}
  gem.summary       = %q{Benchmark extensions}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = %w(benchmark)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w(lib)
  gem.add_dependency('easystats')
end
