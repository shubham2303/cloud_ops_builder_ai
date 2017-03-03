class AddColumnCounterCacheBatches < ActiveRecord::Migration[5.0]
  def change
  	add_column :batches, :batch_details_count, :integer
  end
end
