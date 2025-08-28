class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, null: false
      t.text :address, null: false
      t.string :city, null: false
      t.string :postal_code, null: false
      t.text :items_data, null: false # JSON des articles commandés
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.decimal :delivery_fee, precision: 10, scale: 2, null: false, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.integer :status, default: 0 # pending par défaut
      t.text :notes # Notes optionnelles

      t.timestamps
    end

    add_index :orders, :status
    add_index :orders, :created_at
  end
end
