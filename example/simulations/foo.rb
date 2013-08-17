class Orders
  simulation 'OrdersPage' do
    %w(X Y Z)
  end

  def simulate_items
    some_helper # see SimulationHelpers in init.rb
    order.items
  end

  def simulate_history
    order.history
    sleep(0.1)
  end

  def order
    # more typical would be Order.find(subject)
    @order ||= Struct.new(:order_id, :items, :history).new(:order_id => subject, :items => [], :history => [])
  end
end
