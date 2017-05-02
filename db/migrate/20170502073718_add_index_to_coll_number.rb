class AddIndexToCollNumber < ActiveRecord::Migration[5.0]
  def change
    add_index :collections, :number
  end
end
