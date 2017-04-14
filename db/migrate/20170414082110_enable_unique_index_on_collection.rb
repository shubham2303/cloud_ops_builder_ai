class EnableUniqueIndexOnCollection < ActiveRecord::Migration[5.0]
  def change
    add_index :collections, :uuid, :unique => true
  end
end
