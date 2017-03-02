class CreateCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :collections do |t|
      t.string :category_type
      t.string :subtype
      t.string :number
      t.float :amount
      t.references :agent
      t.references :individual
      t.references :business
      t.references :batch
      t.timestamps
    end
  end
end
