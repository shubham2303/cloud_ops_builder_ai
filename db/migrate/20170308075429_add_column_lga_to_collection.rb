class AddColumnLgaToCollection < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :lga, :string
  end
end
