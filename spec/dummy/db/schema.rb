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

ActiveRecord::Schema.define(version: 20151229184253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "token_auth_authentication_tokens", force: :cascade do |t|
    t.integer "entity_id",                             null: false
    t.string  "value",       limit: 32,                null: false
    t.boolean "is_enabled",             default: true, null: false
    t.string  "uuid",        limit: 36,                null: false
    t.string  "client_uuid",                           null: false
  end

  add_index "token_auth_authentication_tokens", ["client_uuid"], name: "index_token_auth_authentication_tokens_on_client_uuid", unique: true, using: :btree
  add_index "token_auth_authentication_tokens", ["entity_id"], name: "index_token_auth_authentication_tokens_on_entity_id", unique: true, using: :btree
  add_index "token_auth_authentication_tokens", ["value"], name: "index_token_auth_authentication_tokens_on_value", unique: true, using: :btree

  create_table "token_auth_configuration_tokens", force: :cascade do |t|
    t.datetime "expires_at", null: false
    t.string   "value",      null: false
    t.integer  "entity_id",  null: false
  end

  add_index "token_auth_configuration_tokens", ["entity_id"], name: "index_token_auth_configuration_tokens_on_entity_id", unique: true, using: :btree

  create_table "token_auth_synchronizable_resources", force: :cascade do |t|
    t.string   "uuid",                                     null: false
    t.integer  "entity_id",                                null: false
    t.string   "entity_id_attribute_name",                 null: false
    t.string   "name",                                     null: false
    t.string   "class_name",                               null: false
    t.boolean  "is_pullable",              default: false, null: false
    t.boolean  "is_pushable",              default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

end
