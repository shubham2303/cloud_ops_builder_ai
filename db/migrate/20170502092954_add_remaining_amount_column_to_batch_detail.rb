class AddRemainingAmountColumnToBatchDetail < ActiveRecord::Migration[5.0]
  def change
    add_column :batch_details, :remaining_amount, :integer
    BatchDetail.all.each do |bd|
      coll_amount = Collection.where(number: bd.n).sum(:amount)
      if coll_amount == 0
        bd.remaining_amount = bd.amount
      else
        bd.remaining_amount = bd.amount - coll_amount
      end
      bd.save!
    end
  end
end
