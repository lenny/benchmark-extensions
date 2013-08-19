class Manuscript
  simulation 'Manuscript' do
    %w(GA1001 GA1002)
  end

  def simulate_items
    some_helper # see SimulationHelpers in init.rb
    manuscript.items
  end

  def simulate_history
    manuscript.history
    sleep(0.1)
  end

  def manuscript
    # more typical would be Manuscript.find(subject)
    @manuscript ||= Struct.new(:order_id, :items, :history).new(:items => [], :history => [])
  end
end
