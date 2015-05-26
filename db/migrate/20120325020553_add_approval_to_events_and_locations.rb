class AddApprovalToEventsAndLocations < ActiveRecord::Migration
  def change
    add_column :events, :approved, :boolean, default: false
    add_column :locations, :approved, :boolean, default: false
  end
end
