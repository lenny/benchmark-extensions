Database/ORM load testing
==============================

## Usage:

Note: Use JRuby with --1.9

    $ bundle install
    $ ./benchmark --help
    Usage: benchmark [options]
    -h, --help                       Display this screen
    -t, --threads NUM                Number of simultaneous threads per thread group
    -r, --repetitions NUM            Number of repetitions per thread
    -s, --simulation NAME            Run only specified simulation

    $ ./benchmark -t 3 -r 2
                                                  user     system      total        real
    [0][0] ManView AA1001 events              0.420000   0.000000   0.420000 (  0.420000)
    [1][0] ManView AA1001 events              0.210000   0.000000   0.210000 (  0.210000)
    [2][0] ManView AA1001 contact_person      0.003000   0.000000   0.003000 (  0.003000)
    ...
    [1][0] RefView 202998 foo                 0.102000   0.000000   0.102000 (  0.102000)
    ....
    ManView.events                            1.036000   0.000000   1.036000 (  1.036000)
    ManView.contact_person                    0.005000   0.000000   0.005000 (  0.005000)
    ManView                                   1.041000   0.000000   1.041000 (  1.041000)
    RefView.foo                               1.214000   0.000000   1.214000 (  1.214000)
    RefView.bar                               1.214000   0.000000   1.214000 (  1.215000)
    RefView                                   2.428000   0.000000   2.428000 (  2.429000)
    >total:                                   6.938000   0.000000   6.938000 (  6.940000)

## Plugins

Ruby files in the ```simulations/``` directory are automatically loaded.

A class is plugged in to the framework via the ```simulation``` method. ```simulation``` expects a block that returns a list of elements
used to instantiate simulation instances.
An instance of the simulation class will be instantiated for each batch item and all ```simulate_*'```
methods will be executed and benchmarked. The batch item a simulation instance was instantiated
with is accessible as ```#subject```.

e.g.

    class ManView
      simulation 'ManView' do
        %w(AA1001 AA1002)
      end

      def simulate_events
      ....

      def simulate_contact_person
      ...

      private

      def manuscript
        @manuscript ||= Manuscript.find(subject)
      end
    end

### Customizing

The benchmark script loads ```init.rb``` which is where your customizations should go.

To override simulation methods (i.e. to decorate) you can use ```Simulation.add_helper(SimulationHelpers)```
to specify a mixin to be added to all simulation classes.

e.g. # init.rb

    module SimulationHelpers
      def run
        EOPCommon::DoInSession.execute_new { super }
      end
      ....
    end

    Simulation.add_helper(SimulationHelpers)
