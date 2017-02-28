class CreateIndividual < ActiveRecord::Migration[5.0]
  def change
    create_table :individuals do |t|
      t.string :phone
      t.string :name
      t.text :address
      t.string :uuid
      t.timestamps
    end
  end
end
