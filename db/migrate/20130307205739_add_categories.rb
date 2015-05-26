class AddCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string :name, :null => false
    end
    add_column :events, :category_id, :integer#, :null => false # Can't add a non-null column to existing table
  end

  def down
    drop_table :categories
    remove_column :events, :category_id
  end
end
