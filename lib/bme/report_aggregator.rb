require 'easystats'

module BME
  class ReportAggregator
    attr_reader :labels, :keyed_reports, :total, :precision, :label_width

    def initialize(labels, options = {})
      @labels = labels
      @label_width = options.fetch(:label_width, 20)
      @precision = options.fetch(:precision, 5)
      @keyed_reports = {}
      @mutex = Mutex.new
    end

    def report(label, *keys, &blk)
      r = Benchmark.measure(label, &blk)

      @mutex.synchronize do
        @total = total.nil? ? r : total + r
        puts sprintf("%-#{label_width}s #{r}", label)
        keys.each do |k|
          (keyed_reports[k] ||= []) << r
        end
      end
    end

    def stats
      buf = sprintf("%-#{label_width}s #{total}", '>Total:')
      p = precision
      labels.each do |k|
        realtimes = keyed_reports.fetch(k).map(&:real)
        buf << sprintf("%-#{label_width}s total(%.#{p}f) avg(%.#{p}f) median(%.#{p}f) std(%.#{p}f) min(%.#{p}f) max(%.#{p}f)  \n",
                       "#{k}(#{realtimes.size})", realtimes.sum, realtimes.average, realtimes.median, realtimes.standard_deviation, realtimes.min, realtimes.max)
      end
      buf
    end
  end
end
