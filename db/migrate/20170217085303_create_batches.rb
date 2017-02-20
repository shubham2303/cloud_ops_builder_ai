class CreateBatches < ActiveRecord::Migration[5.0]
  def change

    create_table :batches do |t|

      t.string :location
      t.integer :net_worth, null: false
      t.json :details

      t.timestamps
    end

    create_table :batch_details do |t|

      t.string :n, null: false
      t.integer :amount, null: false

      t.references :batch, index: true
      t.timestamps
    end

    create_table :cards do |t|

      t.string :x, null: false
      t.text :y, null: false
      t.text :z, null: false
      t.integer :amount, null: false
      t.integer :usage, null: false, default: 0

      t.references :batch, index: true
      t.timestamps
    end

    add_index :batch_details, [:n], unique: true
    add_index :cards, [:x], unique: true
    add_foreign_key :batch_details, :batches
    add_foreign_key :cards, :batches

  end
end
