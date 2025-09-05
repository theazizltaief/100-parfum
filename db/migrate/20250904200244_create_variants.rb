class CreateVariants < ActiveRecord::Migration[8.0]
  def change
    create_table "variants", force: :cascade do |t|
      t.bigint "parfum_id", null: false
      t.string "size"
      t.decimal "price", precision: 10, scale: 2
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index [ "parfum_id" ], name: "index_variants_on_parfum_id"
    end

    add_foreign_key "variants", "parfums"
  end
end
