module BME
  class Simulation
    extend Enumerable

    class << self
      attr_reader :simulations, :helpers

      def add(simulation_class)
        simulations << simulation_class
      end

      def each(&blk)
        simulations.each(&blk)
      end

      def add_helper(mixin)
        self.helpers << mixin
      end
    end

    @simulations = []
    @helpers = []
  end

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

    private

    def qualified_label
      "#{run_id} #{self.class.label} #{subject}"
    end

    def setup(run_id, aggregator, *args)
      @run_id, @aggregator, @batch_args = run_id, aggregator, args
    end

    def run
      self.class.steps.each do |step|
        aggregator.report(qualified_label, self.class.label, "#{self.class.label}.#{step}" ) { send("simulate_#{step}") }
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
