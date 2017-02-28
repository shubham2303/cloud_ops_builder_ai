class CreateCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :collections do |t|
      t.string :category_type
      t.string :subtype
      t.string :number
      t.float :amount
      t.references :agent, foreign_key: true
      t.references :individual, foreign_key: true
      t.references :business, foreign_key: true
      t.references :batch, foreign_key: true
      t.timestamps
    end
  end
end
