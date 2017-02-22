class AddIndexToIndividual < ActiveRecord::Migration[5.0]
  def change
    add_index "individuals", ["phone"], :unique => true
  end
end
