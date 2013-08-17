require 'benchmarker/version'

module Benchmarker
  autoload :ReportAggregator, 'benchmarker/report_aggregator'
  autoload :Runner, 'benchmarker/runner'
  autoload :Simulation, 'benchmarker/simulation'
end

require 'benchmarker/extensions'

