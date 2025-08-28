class ChangeCategoryAndFragranceClassToIntegerInParfums < ActiveRecord::Migration[8.0]
  def up
    # Conversion string -> integer
    change_column :parfums, :category, :integer, using: 'category::integer'
    change_column :parfums, :fragrance_class, :integer, using: 'fragrance_class::integer'
  end

  def down
    # Si on rollback, repasser en string
    change_column :parfums, :category, :string
    change_column :parfums, :fragrance_class, :string
  end
end
