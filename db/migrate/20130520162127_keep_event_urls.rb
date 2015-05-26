class KeepEventUrls < ActiveRecord::Migration
  def up
    add_column :events, :uri, :string
    add_index :events, :uri
  end

  def down
    remove_column :events, :uri
  end
end
