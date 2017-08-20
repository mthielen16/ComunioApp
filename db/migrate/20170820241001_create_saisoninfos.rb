class CreateSaisoninfos < ActiveRecord::Migration[5.1]
  def change
    create_table "saisoninfos", id: :integer, default: nil, force: :cascade do |t|
      t.integer "cid"
      t.integer "tore"
      t.integer "unknown"
      t.integer "gelb"
      t.integer "gelbrot"
      t.integer "rot"
      t.integer "punkte"
      t.integer "note"
      t.integer "min_ein"
      t.integer "min_aus"
      t.integer "einsätze"
      t.text "heimaus"
      t.text "date"
      t.index ["id"], name: "saison_infos_id_uindex", unique: true
    end
  end
end
