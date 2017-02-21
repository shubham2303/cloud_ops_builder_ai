class AddIndexToAgents < ActiveRecord::Migration[5.0]
  def change
    add_index "agents", ["phone"], :unique => true
  end
end
