class AddUuidToBusiness < ActiveRecord::Migration[5.0]
  def change
    add_column :businesses, :uuid, :string
    add_index :businesses, :uuid, :unique => true
    Business.all.each do |b|
      b.uuid = SecureRandom.uuid
      b.save!
    end
  end
end
