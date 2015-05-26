class RenameLocationsToVenues < ActiveRecord::Migration
  def change
    rename_table :locations, :venues
    rename_column :events, :location_id, :venue_id
  end
end
