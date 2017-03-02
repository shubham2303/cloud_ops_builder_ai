class AddColumnCountToBatches < ActiveRecord::Migration[5.0]
  def change
    add_column :batches, :count, :integer
  end
end
