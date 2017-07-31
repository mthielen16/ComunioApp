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

ActiveRecord::Schema.define(version: 20170730167305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", force: :cascade do |t|
    t.integer "comunioid"
    t.text "name"
    t.text "position"
    t.text "verein"
    t.integer "punkte"
    t.decimal "pps"
    t.integer "2017-06-16"
    t.integer "2017-06-17"
    t.integer "2017-06-18"
    t.integer "2017-06-19"
    t.integer "2017-06-20"
    t.integer "2017-06-21"
    t.integer "2017-06-22"
    t.integer "2017-06-23"
    t.integer "2017-06-24"
    t.integer "2017-06-25"
    t.integer "2017-06-26"
    t.integer "2017-06-27"
    t.integer "2017-06-28"
    t.integer "2017-06-29"
    t.integer "2017-06-30"
    t.integer "2017-07-01"
    t.integer "2017-07-02"
    t.integer "2017-07-03"
    t.integer "2017-07-04"
    t.integer "2017-07-05"
    t.integer "2017-07-06"
    t.integer "2017-07-07"
    t.integer "2017-07-08"
    t.integer "2017-07-09"
    t.integer "2017-07-10"
    t.integer "2017-07-11"
    t.integer "2017-07-12"
    t.integer "2017-07-13"
    t.integer "2017-07-14"
    t.integer "2017-07-15"
    t.integer "2017-07-16"
    t.integer "2017-07-17"
    t.integer "2017-07-18"
    t.integer "2017-07-19"
    t.integer "2017-07-20"
    t.integer "2017-07-21"
    t.integer "2017-07-22"
    t.integer "2017-07-23"
    t.integer "2017-07-24"
    t.integer "2017-07-25"
    t.integer "2017-07-26"
    t.integer "2017-07-27"
    t.integer "2017-07-28"
    t.integer "2017-07-29"
    t.integer "2017-07-30"
    t.index ["id"], name: "players_id_uindex", unique: true
  end

end
