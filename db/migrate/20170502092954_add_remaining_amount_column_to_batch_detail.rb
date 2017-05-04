class AddRemainingAmountColumnToBatchDetail < ActiveRecord::Migration[5.0]
  def change
    add_column :batch_details, :remaining_amount, :integer
    BatchDetail.update_all('remaining_amount = batch_details.amount - (SELECT SUM(collections.amount) FROM collections WHERE collections.number = batch_details.n)')
  end
end
