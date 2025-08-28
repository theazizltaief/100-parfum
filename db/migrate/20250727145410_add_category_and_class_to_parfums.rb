class AddCategoryAndClassToParfums < ActiveRecord::Migration[8.0]
  def change
    add_column :parfums, :category, :string
    add_column :parfums, :fragrance_class, :string
  end
end
