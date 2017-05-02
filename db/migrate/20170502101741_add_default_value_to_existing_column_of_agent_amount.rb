class AddDefaultValueToExistingColumnOfAgentAmount < ActiveRecord::Migration[5.0]
  def change
    Agent.where(amount: nil).each do |a|
      a.update!(amount: 0.0)
    end
  end
end
