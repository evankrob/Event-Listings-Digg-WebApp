class AddDescriptionToEvents < ActiveRecord::Migration
  def change
    add_column :events, :description, :text
    remove_column :events, :starts_at
    remove_column :events, :ends_at
  end
end
