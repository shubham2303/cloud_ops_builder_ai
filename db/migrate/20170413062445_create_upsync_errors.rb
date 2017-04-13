class CreateUpsyncErrors < ActiveRecord::Migration[5.0]
  def change
    create_table :upsync_errors do |t|
      t.json :error
      t.references :agent
      t.string :message
      t.timestamps
    end
  end
end
