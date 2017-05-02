class AddDefaultValueToAgentAmount < ActiveRecord::Migration[5.0]
  def up
    change_column :agents, :amount, :float, :default => 0.0
  end

  def down
    change_column :agents, :amount, :float, :default => nil
  end
end
