# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150428211137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "token_auth_authentication_tokens", force: :cascade do |t|
    t.integer "participant_id",                           null: false
    t.string  "value",          limit: 32,                null: false
    t.boolean "is_enabled",                default: true, null: false
    t.string  "uuid",           limit: 36,                null: false
    t.string  "client_uuid",                              null: false
  end

  add_index "token_auth_authentication_tokens", ["client_uuid"], name: "index_token_auth_authentication_tokens_on_client_uuid", unique: true, using: :btree
  add_index "token_auth_authentication_tokens", ["participant_id"], name: "index_token_auth_authentication_tokens_on_participant_id", unique: true, using: :btree
  add_index "token_auth_authentication_tokens", ["value"], name: "index_token_auth_authentication_tokens_on_value", unique: true, using: :btree

  create_table "token_auth_configuration_tokens", force: :cascade do |t|
    t.datetime "expires_at",     null: false
    t.string   "value",          null: false
    t.integer  "participant_id", null: false
  end

  add_index "token_auth_configuration_tokens", ["participant_id"], name: "index_token_auth_configuration_tokens_on_participant_id", unique: true, using: :btree

end
