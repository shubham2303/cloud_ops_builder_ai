class AddCreatedAtIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :individuals, :created_at
    add_index :agents, :created_at
    add_index :businesses, :created_at
    add_index :collections, :created_at
  end
end
