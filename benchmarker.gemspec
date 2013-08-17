# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'benchmarker/version'

Gem::Specification.new do |gem|
  gem.name          = 'benchmarker'
  gem.version       = Benchmarker::VERSION
  gem.authors       = ['Lenny Marks']
  gem.email         = %w(lenny@aps.org)
  gem.description   = %q{Benchmark framework}
  gem.summary       = %q{Benchmark framework}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = %w(benchmark)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w(lib)
  gem.add_dependency('easystats')
end
