class AddDisponibleToParfums < ActiveRecord::Migration[8.0]
  def change
  add_column :parfums, :disponible, :boolean, default: true
  end
end
