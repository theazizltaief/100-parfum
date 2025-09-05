class RemovePrixFromParfums < ActiveRecord::Migration[8.0]
  def change
    remove_column :parfums, :prix, :decimal
  end
end
