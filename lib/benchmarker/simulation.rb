module Benchmarker
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
end
