class AddVenueIndexes < ActiveRecord::Migration
  def change
    add_index :venues, :name
    add_index :venues, :city
  end
end
