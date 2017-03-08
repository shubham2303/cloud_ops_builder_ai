class AddPolymorhicToCollection < ActiveRecord::Migration[5.0]
  def change
    change_table :collections do |t|
      t.remove_references :business
      t.references :collectionable, :polymorphic => true
    end
  end

end
