class AddUuidToCollection < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :uuid, :string
    add_index :collections, :uuid, :unique => true
    Collection.all.each do |b|
      begin
        b.uuid = Collection.generate_uuid(b.agent_id || 0, b.created_at)
        b.save!
      rescue
        try_again(b)
      end
    end
  end

  def try_again(b)
    begin
      b.uuid = 15.times.map{rand(10)}.join
      b.save!
    rescue
      try_again(b)
    end
  end
end
