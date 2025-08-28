class AddDescriptionToParfums < ActiveRecord::Migration[8.0]
  def change
    add_column :parfums, :description, :text
  end
end
