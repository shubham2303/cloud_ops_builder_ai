class CreateVehicle < ActiveRecord::Migration[5.0]
  def change
    create_table :vehicles do |t|
      t.string :vehicle_number
      t.string :lga
      t.references :individual
      t.timestamps
    end
    add_index :vehicles, [:vehicle_number], unique: true
    add_index :vehicles, [:individual_id, :vehicle_number]
  end
end
