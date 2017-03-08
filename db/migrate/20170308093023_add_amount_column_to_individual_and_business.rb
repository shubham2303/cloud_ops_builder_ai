class AddAmountColumnToIndividualAndBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :individuals, :amount, :float, default: 0.0
    add_column :businesses, :amount, :float, default: 0.0
  end
end
