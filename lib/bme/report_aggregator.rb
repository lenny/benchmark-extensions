require 'easystats'

module BME
  class ReportAggregator
    attr_reader :labels, :keyed_reports, :total, :precision, :label_width, :column_width

    def initialize(labels, options = {})
      @labels = labels
      @label_width = options.fetch(:label_width, 20)
      @column_width = options.fetch(:column_width, 15)
      @precision = options.fetch(:precision, 5)
      @keyed_reports = {}
      @mutex = Mutex.new
    end

    def report(label, *keys, &blk)
      r = Benchmark.measure(label, &blk)

      @mutex.synchronize do
        @total = total.nil? ? r : total + r
        puts report_s(r, label)
        keys.each do |k|
          (keyed_reports[k] ||= []) << r
        end
      end
    end

    def table_header
      w = column_width
      sprintf("%-#{label_width}s %-#{w}s %-#{w}s %-#{w}s %s", '', 'user', 'system', 'total', 'real')
    end

    def stats
      buf = report_s(total, '>Total:')
      p = precision
      labels.each do |k|
        realtimes = keyed_reports.fetch(k).map(&:real)
        buf << sprintf("%-#{label_width}s total(%.#{p}f) avg(%.#{p}f) median(%.#{p}f) std(%.#{p}f) min(%.#{p}f) max(%.#{p}f)  \n",
                       "#{k}(#{realtimes.size})", realtimes.sum, realtimes.average, realtimes.median, realtimes.standard_deviation, realtimes.min, realtimes.max)
      end
      buf
    end

    private

    def report_s(r, label)
      w = column_width
      sprintf("%-#{label_width}s #{r.format("%-#{w}u %-#{w}y %-#{w}t %r")}\n", label)
    end
  end
end
