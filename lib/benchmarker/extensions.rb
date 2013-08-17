module Benchmarker
  module SimulationClassMethods
    def steps
      instance_methods.map { |m| m[/^simulate_(.*)/, 1] }.compact
    end

    def run(run_id, aggregator)
      batch.each do |*args|
        s = new
        s.send(:setup, run_id, aggregator, *args)
        s.send(:run)
        s
      end
    end
  end

  module SimulationInstanceMethods
    attr_reader :run_id, :aggregator, :batch_args

    def subject
      batch_args.first
    end

    def qualified_label
      "#{run_id} #{self.class.label} #{subject}"
    end

    private

    def setup(run_id, aggregator, *args)
      @run_id, @aggregator, @batch_args = run_id, aggregator, args
    end

    def run
      self.class.steps.each do |step|
        aggregator.report(self, step) { send("simulate_#{step}") }
      end
    end
  end

  module SimulationExtension
    def simulation(label = name, &blk)
      Simulation.add(self)

      define_singleton_method(:batch, &blk)
      define_singleton_method(:label) { label }

      extend SimulationClassMethods
      include SimulationInstanceMethods

      Simulation.helpers.each do |h|
        include h
      end
    end
  end

  Class.send(:include, SimulationExtension)
end
