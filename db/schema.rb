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

ActiveRecord::Schema.define(version: 2018_08_11_130903) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "communications", force: :cascade do |t|
    t.bigint "event_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_communications_on_event_id"
  end

  create_table "event_venues", force: :cascade do |t|
    t.string "token"
    t.integer "event_id"
    t.string "place_id"
    t.string "name"
    t.string "prefecture"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_venues_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "token"
    t.string "name"
    t.string "url"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean "flag_all_day", default: true
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sponsor"
    t.string "sponsor_url"
    t.string "organizer"
    t.string "organizer_affiliation"
    t.string "source"
    t.string "category"
    t.string "country"
    t.integer "num_event"
    t.jsonb "related_events"
    t.jsonb "google_cse_result"
  end

  create_table "provisional_events", force: :cascade do |t|
    t.string "token"
    t.string "name"
    t.string "url"
    t.string "sponsor"
    t.string "sponsor_url"
    t.string "organizer"
    t.string "organizer_affiliation"
    t.string "source"
    t.string "category"
    t.integer "num_event"
    t.string "country"
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean "flag_all_day", default: true
    t.text "content"
    t.jsonb "place"
    t.jsonb "normalized_place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "venues", force: :cascade do |t|
    t.string "token"
    t.string "place_id"
    t.jsonb "result_cache", default: "{}"
    t.string "name"
    t.string "postal_code"
    t.string "country"
    t.string "prefecture"
    t.string "city"
    t.string "ward"
    t.string "formatted_address"
    t.string "formatted_phone_number"
    t.float "latitude"
    t.float "longitude"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_venues_on_place_id"
  end

end
