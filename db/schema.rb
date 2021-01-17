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

ActiveRecord::Schema.define(version: 2021_01_17_172751) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airlines", force: :cascade do |t|
    t.string "name"
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_airlines_on_name", unique: true
  end

  create_table "airplanes", force: :cascade do |t|
    t.string "model"
    t.string "tail_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "airlines_id"
    t.index ["airlines_id"], name: "index_airplanes_on_airlines_id"
    t.index ["tail_number"], name: "index_airplanes_on_tail_number", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.string "short_name"
    t.string "full_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["short_name", "full_name"], name: "index_cities_on_short_name_and_full_name", unique: true
  end

  create_table "flights", force: :cascade do |t|
    t.string "flight_no"
    t.datetime "arrival"
    t.datetime "departure"
    t.integer "source"
    t.integer "destination"
    t.integer "seats"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "airplanes_id"
    t.integer "cost", default: 1200, null: false
    t.index ["airplanes_id"], name: "index_flights_on_airplanes_id"
    t.index ["flight_no"], name: "index_flights_on_flight_no", unique: true
    t.index ["source", "destination"], name: "index_flights_on_source_and_destination"
  end

  add_foreign_key "airplanes", "airlines", column: "airlines_id"
  add_foreign_key "flights", "airplanes", column: "airplanes_id"
  add_foreign_key "flights", "cities", column: "destination"
  add_foreign_key "flights", "cities", column: "source"
end
