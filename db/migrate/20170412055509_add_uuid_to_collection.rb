class AddUuidToCollection < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :uuid, :string
    add_index :collections, :uuid, :unique => true
    Collection.all.each do |b|
      b.uuid = Collection.generate_uuid(b.agent.id, b.created_at)
      b.save!
    end
  end
end
