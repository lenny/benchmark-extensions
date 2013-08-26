class Referee 
  simulation 'Referee' do
    %w(A B)
  end

  def simulate_items
    some_helper # see SimulationHelpers in init.rb
    referee.items
  end

  def simulate_history
    referee.history
    sleep(0.1)
  end

  def referee 
    # more typical would be Referee.find(subject)
    @referee ||= Struct.new(:order_id, :items, :history).new
  end
end
