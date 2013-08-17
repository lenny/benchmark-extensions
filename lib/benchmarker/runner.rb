module Benchmarker
  class Runner
    class << self
      def run(threads, repetitions, &blk)
        thread_group = []
        threads.times do |thread_index|
          thread_group << Thread.new do
            repetitions.times do |i|
              blk.call("[#{thread_index}][#{i}]")
            end
          end
        end
        thread_group.map(&:join)
      end
    end
  end
end
