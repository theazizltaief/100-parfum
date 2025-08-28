class CreateParfums < ActiveRecord::Migration[8.0]
  def change
    create_table :parfums do |t|
      t.string :name
      t.text :description
      t.decimal :prix
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
