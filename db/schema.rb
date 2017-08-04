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

ActiveRecord::Schema.define(version: 20170803142716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", id: :integer, default: nil, force: :cascade do |t|
    t.text "name"
    t.text "position"
    t.text "verein"
    t.integer "punkte"
    t.decimal "pps"
    t.index ["id"], name: "players_cid_uindex", unique: true
  end

  create_table "values", primary_key: "pk", id: :serial, force: :cascade do |t|
    t.integer "id"
    t.text "date"
    t.integer "value"
    t.index ["pk"], name: "values_pk_uindex", unique: true
  end

  add_foreign_key "values", "players", column: "id", name: "values_players_id_fk"
end
