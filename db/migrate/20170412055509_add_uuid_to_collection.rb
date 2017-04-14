class AddUuidToCollection < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :uuid, :string
  end
end
