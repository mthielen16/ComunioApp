class CreateValues < ActiveRecord::Migration[5.1]
  def change
    create_table "values", cid: false, force: :cascade do |t|
      t.integer "pk"
      t.integer "id"
      t.text "date"
      t.integer "value"
    end
  end
end
