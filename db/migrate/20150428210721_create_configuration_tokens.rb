module CreateConfigurationTokensMigration
  def change
    create_table :token_auth_configuration_tokens do |t|
      t.datetime :expires_at, null: false
      t.string :value, null: false
      t.integer :entity_id, null: false
    end

    add_index :token_auth_configuration_tokens, :entity_id, unique: true
  end
end

if ActiveRecord::Migration.respond_to? :[]
  class CreateConfigurationTokens < ActiveRecord::Migration[4.2]
    include CreateConfigurationTokensMigration
  end
else
  class CreateConfigurationTokens < ActiveRecord::Migration
    include CreateConfigurationTokensMigration
  end
end
