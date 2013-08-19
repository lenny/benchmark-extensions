Ruby benchmark extensions
==============================

* ```BME::Runner.run(threads, repetitions, &blk)``` - Run block of code in :threads threads, :repetition times each thread.
  <pre>
    BME::Runner.run(2, 2) do |run_id|
      puts run_id
    end

    [0][0]
    [0][1]
    [1][0]
    [1][1]
  </pre>
* ```BME::ReportAggregator``` - Threadsafe aggregating wrapper around ```#report``` from SDK Benchmark.
  See: [examples/report_aggregator.rb](examples/report_aggregator.rb)
* ```benchmark``` executable - A mini-framework with automatic discovery and statistic reporting for pluggable ```simulations```.
  <pre>
    $ bundle exec benchmark --help
    Usage: benchmark [options]
    -h, --help                       Display this screen
    -t, --threads NUM                Number of simultaneous threads per thread group
    -r, --repetitions NUM            Number of repetitions per thread
    -s, --simulation NAME            Run only specified simulation

    $ bundle exec benchmark -s ManView -t 3 -r 2
                                                    user     system      total        real
      [1][0] ManView GA1001                     0.088000   0.000000   0.088000 (  0.086000)
      [1][0] ManView GA1001                     0.020000   0.000000   0.020000 (  0.020000)
      .....
      ManView.history                           0.224000   0.000000   0.224000 (  0.222000)
      ManView.tracking_info                     0.091000   0.000000   0.091000 (  0.091000)
      ManView.related_manuscripts               0.209000   0.000000   0.209000 (  0.209000)
      ManView.contact_info                      0.322000   0.000000   0.322000 (  0.322000)
      .....
      ManView                                   3.251001   0.000000   3.251001 (  3.252001)
      >total:                                   3.251001   0.000000   3.251001 (  3.252001)

      ManView.history(12)                      total(0.22200) avg(0.01850) median(0.00950) std(0.02259) min(0.00500) max(0.08600)
      ManView.tracking_info(12)                total(0.09100) avg(0.00758) median(0.00450) std(0.00682) min(0.00200) max(0.02000)
      ManView.related_manuscripts(12)          total(0.20900) avg(0.01742) median(0.01100) std(0.01274) min(0.00800) max(0.04800)
      ManView.contact_info(12)                 total(0.32200) avg(0.02683) median(0.01650) std(0.02814) min(0.00700) max(0.09900)
      .....
      ManView(216)                             total(3.25200) avg(0.01506) median(0.00500) std(0.03255) min(0.00000) max(0.32000)
  </pre>
  
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
        %w(GA1001 GA1002)
      end

      def simulate_events
      ....

      def simulate_contact_info
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
