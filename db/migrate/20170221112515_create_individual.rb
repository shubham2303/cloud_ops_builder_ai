class CreateIndividual < ActiveRecord::Migration[5.0]
  def change
    create_table :individuals do |t|
      t.string :phone
      t.string :name
      t.string :address
      t.string :pid
    end
  end
end
