class AddSyncTimersToAgents < ActiveRecord::Migration[5.0]
  def up
    add_column :agents, :amount, :float
    add_column :agents, :last_downsync, :datetime
    add_column :agents, :last_coll_offline, :datetime
    add_column :agents, :last_coll_online, :datetime

    Agent.all.each do |a|
      latest_online_collection = a.collections.where('created_at = updated_at').order(updated_at: :DESC).limit(1).first
      latest_offline_collection = a.collections.where('NOT created_at = updated_at').order(updated_at: :DESC).limit(1).first
      total_collection = a.collections.sum(:amount)
      update_params = {}
      if total_collection && total_collection > 0
        update_params[:amount] = total_collection
      end
      if latest_online_collection
        update_params[:last_coll_online] = latest_online_collection.updated_at
      end
      if latest_offline_collection
        update_params[:last_coll_offline] = latest_offline_collection.updated_at
        update_params[:last_downsync] = latest_offline_collection.updated_at
      end
      unless update_params.empty?
        a.update update_params
      end
    end
  end

  def down
    remove_column :agents, :amount
    remove_column :agents, :last_downsync
    remove_column :agents, :last_coll_offline
    remove_column :agents, :last_coll_online
  end

end
