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

ActiveRecord::Schema.define(version: 20160919094220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.datetime "started_at",  null: false
    t.datetime "finished_at", null: false
    t.integer  "steps_count", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source",      null: false
  end

  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "auth_phone_codes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "phone_code"
    t.datetime "expire_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auth_phone_codes", ["user_id"], name: "index_auth_phone_codes_on_user_id", using: :btree

  create_table "fitness_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token",         null: false
    t.integer  "source",        null: false
    t.string   "refresh_token"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "fitness_tokens", ["user_id"], name: "index_fitness_tokens_on_user_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number",                      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "zendesk_id"
    t.string   "avatar"
    t.integer  "provider_id"
    t.string   "project_id"
    t.string   "member_number"
    t.string   "street_number"
    t.string   "street_name"
    t.string   "street_type"
    t.string   "suburb"
    t.string   "state"
    t.string   "postcode"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", unique: true, using: :btree
  add_index "users", ["provider_id"], name: "index_users_on_provider_id", using: :btree

  add_foreign_key "fitness_tokens", "users"
end
