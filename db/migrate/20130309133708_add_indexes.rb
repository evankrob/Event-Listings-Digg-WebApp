class AddIndexes < ActiveRecord::Migration
  def change
    add_index :events, :location_id
    add_index :events, :category_id

    add_index :occurrences, :event_id
  end
end
