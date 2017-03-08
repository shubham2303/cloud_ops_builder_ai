class AddCloumnLgaToIndividual < ActiveRecord::Migration[5.0]
  def change
    add_column :individuals, :lga, :string
  end
end
