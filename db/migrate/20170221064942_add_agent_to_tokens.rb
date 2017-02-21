class AddAgentToTokens < ActiveRecord::Migration[5.0]
  def change
    add_reference :tokens, :agent, foreign_key: true
  end
end
