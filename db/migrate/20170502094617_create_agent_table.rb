class CreateAgentTable < ActiveRecord::Migration[5.0]
  def change
    create_table :agent_tables do |t|
      t.string :migration_version
      t.string :migration_target
      t.json :extras
      t.integer :agent_id
    end
    add_index :agent_tables, :agent_id
  end
end
