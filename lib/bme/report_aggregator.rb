require 'easystats'

module BME
  class ReportAggregator
    attr_reader :keyed_reports, :benchmark, :reports

    def initialize(benchmark)
      @benchmark = benchmark
      @keyed_reports = {}
      @reports = []
      @mutex = Mutex.new
    end

    def report(label, *keys, &blk)
      @mutex.synchronize do
        reports << r = benchmark.report(label, &blk)
        keys.each do |k|
          (keyed_reports[k] ||= []) << r
        end
      end
    end

    def totals(labels)
      totals = labels.reduce([]) { |l, label| l << tally(keyed_reports.fetch(label)); l }
      totals << tally(reports)
      totals
    end

    def tally(l)
      l.reduce { |r, total| total += r }
    end

    def stats(width, precision, labels)
      buf = ''
      p = precision
      labels.each do |k|
        realtimes = keyed_reports.fetch(k).map(&:real)
        buf << sprintf("%-#{width}s num(%10.10d) total(%.#{p}f) avg(%.#{p}f) median(%.#{p}f) std(%.#{p}f) min(%.#{p}f) max(%.#{p}f)  \n",
                       k, realtimes.size, realtimes.sum, realtimes.average, realtimes.median, realtimes.standard_deviation, realtimes.min, realtimes.max)
      end
      buf
    end
  end
end
