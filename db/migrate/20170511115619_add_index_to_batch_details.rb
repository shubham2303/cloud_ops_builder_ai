class AddIndexToBatchDetails < ActiveRecord::Migration[5.0]
  def change
    add_index :batch_details, [:updated_at, :id, :created_at]
    add_index :batch_details, [:updated_at, :created_at]
    add_index :batch_details, [:id, :created_at]
  end
end

