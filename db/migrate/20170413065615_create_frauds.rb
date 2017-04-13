class CreateFrauds < ActiveRecord::Migration[5.0]
  def change
    create_table :frauds do |t|
      t.json :error
      t.references :object, :polymorphic => true
      t.references :agent
      t.string :message
      t.timestamps
    end
  end
end
