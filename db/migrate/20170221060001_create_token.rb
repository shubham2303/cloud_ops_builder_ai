class CreateToken < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.string :device_id
      t.string :token
      t.time :expiry
      t.timestamps
    end
  end
end
