#!/usr/bin/env ruby

ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)

require 'bundler'
Bundler.setup

require 'benchmark'
require 'benchmark-extensions'

labels = %w(groupa.foo groupa.bar groupa.baz groupa)
labels.concat %w(groupb.foo groupb.bar groupb.baz groupb)
labels.concat %w(foo bar baz)

aggregator = BME::ReportAggregator.new(labels, :label_width => 40, :precision => 3)

BME::Runner.run(2, 2) do |runner|
  runner << lambda do |run_id|
    3.times do |i|
      aggregator.report("#{run_id} #{i} groupa.foo", 'groupa.foo', 'groupa', 'foo') { sleep(0.1) }
      aggregator.report("#{run_id} #{i} groupa.bar", 'groupa.bar', 'groupa', 'bar') { sleep(0.1) }
      aggregator.report("#{run_id} #{i} groupa.baz", 'groupa.baz', 'groupa', 'baz') { sleep(0.1) }
    end
  end

  runner << lambda do |run_id|
    3.times do |i|
      aggregator.report("#{run_id} #{i} grouba.foo", 'groupb.foo', 'groupb', 'foo') { sleep(0.1) }
      aggregator.report("#{run_id} #{i} groupb.bar", 'groupb.bar', 'groupb', 'baz') { sleep(0.1) }
      aggregator.report("#{run_id} #{i} groupb.baz", 'groupb.baz', 'groupb', 'baz') { sleep(0.1) }
    end
  end
end

puts aggregator.stats

