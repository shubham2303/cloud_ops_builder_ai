class CreateBusiness < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :address
      t.string :category
      t.float :turnover
      t.string :year
      t.string :lga
      t.string :guid
      t.references :individual, foreign_key: true
    end
  end
end
