class AddColumnAmountToVehicle < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :amount, :float, default: 0.0
  end
end
