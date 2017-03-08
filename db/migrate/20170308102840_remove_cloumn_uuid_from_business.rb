class RemoveCloumnUuidFromBusiness < ActiveRecord::Migration[5.0]
  def change
    remove_column :businesses, :uuid, :string
  end
end
