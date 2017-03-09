class AdIndexToLga < ActiveRecord::Migration[5.0]
  def change
  	add_index :individuals, :lga
    add_index :businesses, :lga
    add_index :collections, :lga
  end
end
