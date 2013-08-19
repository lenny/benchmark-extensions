# Fake transaction like class for demonstration purposese
class Transaction
  class << self
    def exec(&blk)
      blk.call
    end
  end
end

module SimulationHelpers
   def run
     Transaction.exec { super }
   end

   def some_helper
     'foo'
   end
end

BME::Simulation.add_helper(SimulationHelpers)
