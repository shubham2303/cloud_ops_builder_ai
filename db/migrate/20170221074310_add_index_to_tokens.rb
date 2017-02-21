class AddIndexToTokens < ActiveRecord::Migration[5.0]
  def change
    add_index "tokens", ["device_id"], :unique => true
  end
end
