class AddFieldsToAgents < ActiveRecord::Migration[5.0]
  def change
    add_column :agents, :dob, :date
    add_column :agents, :lga, :string
  end
end
