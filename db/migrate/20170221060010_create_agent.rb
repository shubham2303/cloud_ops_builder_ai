class CreateAgent < ActiveRecord::Migration[5.0]
  def change
    create_table :agents do |t|
      t.string :phone
      t.string :name
      t.string :address
      t.string :birthplace
      t.string :state
    end
  end
end
