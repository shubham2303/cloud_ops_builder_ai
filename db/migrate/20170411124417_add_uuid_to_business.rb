class AddUuidToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :uuid, :string
    add_index :businesses, :uuid
    Business.all.each do |b|
      b.uuid = ShortUUID.unique
      b.save!
    end
  end
end
