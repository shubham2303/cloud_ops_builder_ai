class AddIndexToInvidualAndBusiness < ActiveRecord::Migration[5.0]
  def change
    add_index :individuals, :uuid, :unique => true
    add_index :businesses, :uuid, :unique => true
  end
end
