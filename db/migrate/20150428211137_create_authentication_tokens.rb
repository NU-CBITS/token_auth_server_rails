module CreateAuthenticationTokensMigration
  def change
    create_table :token_auth_authentication_tokens do |t|
      t.integer :entity_id, null: false
      t.string :value, null: false, limit: ::TokenAuth::AuthenticationToken::TOKEN_LENGTH
      t.boolean :is_enabled, null: false, default: true
      t.string :uuid, null: false, limit: ::TokenAuth::AuthenticationToken::UUID_LENGTH
      t.string :client_uuid, null: false
    end

    add_index :token_auth_authentication_tokens, :entity_id, unique: true
    add_index :token_auth_authentication_tokens, :value, unique: true
    add_index :token_auth_authentication_tokens, :client_uuid, unique: true
  end
end

if ActiveRecord::Migration.respond_to? :[]
  class CreateAuthenticationTokens < ActiveRecord::Migration[4.2]
    include CreateAuthenticationTokensMigration
  end
else
  class CreateAuthenticationTokens < ActiveRecord::Migration
    include CreateAuthenticationTokensMigration
  end
end
