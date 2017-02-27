class CreateAgent < ActiveRecord::Migration[5.0]
  def change
    create_table :agents do |t|
      t.string :phone
      t.string :name
      t.text :address
      t.string :birthplace
      t.string :state
      t.timestamps
    end
  end
end
