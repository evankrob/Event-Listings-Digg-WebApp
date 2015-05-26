class AddEventHtmlHtmlDescription < ActiveRecord::Migration
  def up
    add_column :events, :html_description, :text
  end

  def down
    remove_column :events, :html_description
  end
end
