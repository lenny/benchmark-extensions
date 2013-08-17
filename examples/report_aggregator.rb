#!/usr/bin/env ruby

ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)

require 'bundler'
Bundler.setup

require 'benchmark'
require 'benchmark-extensions'

labels = %w(foo bar baz)

Benchmark.bm(40, *labels, '>total:') do |bm|
  aggregator = BME::ReportAggregator.new(bm)

  10.times do
    aggregator.report('foo') { sleep(0.1) }
    aggregator.report('bar') { sleep(0.1) }
    aggregator.report('baz') { sleep(0.1) }
  end

  aggregator.totals(labels)
end

puts "\n#{aggregator.stats(40, 5, labels)}"

