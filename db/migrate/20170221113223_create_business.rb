class CreateBusiness < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.text :address
      t.float :turnover
      t.string :year
      t.string :lga
      t.string :uuid
      t.references :individual, foreign_key: true
      t.timestamps
    end
  end
end
