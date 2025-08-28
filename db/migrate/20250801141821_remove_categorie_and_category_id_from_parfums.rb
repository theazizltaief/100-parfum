class RemoveCategorieAndCategoryIdFromParfums < ActiveRecord::Migration[8.0]
  def change
    remove_column :parfums, :categorie, :string
    remove_column :parfums, :category_id, :integer
  end
end
