class AddDefaultValueToExistingColumnOfAgentAmount < ActiveRecord::Migration[5.0]
  def change
    Agent.where(amount: nil).update_all(amount: 0.0)
  end
end
