class RemoveCloumnNameAndAddFNameLName < ActiveRecord::Migration[5.0]
  def change
    remove_column :agents, :name, :string
    remove_column :individuals, :name, :string

    add_column :agents, :first_name, :string
    add_column :agents, :last_name, :string
    add_column :individuals, :first_name, :string
    add_column :individuals, :last_name, :string

  end
end
