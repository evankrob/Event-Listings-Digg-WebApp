class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :location_id
      t.string :url

      t.timestamps
    end
  end
end
