class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table "players", primary_key: "cid", cid: :integer, default: nil, force: :cascade do |t|
      t.integer "id"
      t.text "name"
      t.text "position"
      t.text "verein"
      t.integer "punkte"
      t.decimal "pps"
      t.index ["cid"], name: "players_cid_uindex", unique: true
    end
  end
end
