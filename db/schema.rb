# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_27_002802) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_identifiers", force: :cascade do |t|
    t.string "provider_name", null: false
    t.string "provider_id", null: false
    t.string "identifiable_type", null: false
    t.bigint "identifiable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifiable_type", "identifiable_id"], name: "index_api_identifiers_on_identifiable"
    t.index ["provider_name", "provider_id", "identifiable_type"], name: "idx_unique_api_identifiers", unique: true
  end

  create_table "footballers", force: :cascade do |t|
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "digest", null: false
    t.index ["digest"], name: "index_footballers_on_digest", unique: true
  end

  create_table "guesses", force: :cascade do |t|
    t.uuid "round_id", null: false
    t.text "message", null: false
    t.string "response", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_guesses_on_round_id"
  end

  create_table "rounds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "footballer_id", null: false
    t.integer "total_guesses", default: 0
    t.string "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["footballer_id"], name: "index_rounds_on_footballer_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo", null: false
    t.string "league", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "idx_unique_name", unique: true
  end

  add_foreign_key "guesses", "rounds"
  add_foreign_key "rounds", "footballers"
end
