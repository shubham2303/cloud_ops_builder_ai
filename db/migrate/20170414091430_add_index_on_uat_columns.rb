class AddIndexOnUatColumns < ActiveRecord::Migration[5.0]
  def change
    add_index :individuals, :updated_at
    add_index :businesses, :updated_at
    add_index :vehicles, :updated_at
    add_index :batch_details, :updated_at
  end
end
