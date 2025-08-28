class RemoveDescriptionFromParfums < ActiveRecord::Migration[8.0]
  def change
    remove_column :parfums, :description, :string
  end
end
