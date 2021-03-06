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

ActiveRecord::Schema.define(version: 20200524201049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "btree_gist"

  create_table "chores", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "starts_at",  null: false
    t.datetime "ends_at",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "user_id, tsrange(starts_at, ends_at, '[]'::text)", name: "no_overlapping_chores_for_user", using: :gist
    t.index ["user_id"], name: "index_chores_on_user_id", using: :btree
  end

  create_table "data_migrations", id: false, force: :cascade do |t|
    t.string "version", null: false
    t.index ["version"], name: "unique_data_migrations", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "chores", "users"

  create_range_partition "events", partition_key: '((("timestamp")::date))' do |t|
    t.bigserial "id",         null: false
    t.string    "event_type", null: false
    t.integer   "value",      null: false
    t.datetime  "timestamp",  null: false
    t.datetime  "created_at", null: false
    t.datetime  "updated_at", null: false
    t.integer   "user_id"
  end

  add_index "events", ["event_type"], name: "index_events_on_event_type", using: :btree
  add_index "events", ["id", "event_type"], name: "index_events_on_event_type_and_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  add_foreign_key "events", "users"
end
