module BME
  class Runner
    class << self
      def run(threads, repetitions, &blk)
        groups = []
        blk.call(groups)
        thread_group = []
        threads.times do |thread_index|
          groups.each_with_index do |g, group_index|
            thread_group << Thread.new do
              repetitions.times do |i|
                g.call("[#{group_index}][#{thread_index}][#{i}]")
              end
            end
          end
        end
        thread_group.map(&:join)
      end
    end
  end
end
