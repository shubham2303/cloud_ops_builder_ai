class AddIndexToInvidualAndBusiness < ActiveRecord::Migration[5.0]
  def change
    add_index :individuals, :uuid
    add_index :businesses, :uuid
  end
end
