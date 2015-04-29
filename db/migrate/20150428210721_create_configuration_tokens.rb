class CreateConfigurationTokens < ActiveRecord::Migration
  def change
    create_table :token_auth_configuration_tokens do |t|
      t.datetime :expires_at, null: false
      t.string :value, null: false
      t.integer :participant_id, null: false
    end

    add_index :token_auth_configuration_tokens, :participant_id, unique: true
  end
end
