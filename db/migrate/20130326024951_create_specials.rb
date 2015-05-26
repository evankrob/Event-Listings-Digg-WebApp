class CreateSpecials < ActiveRecord::Migration
  def up
    create_table :specials do |t|
      t.integer :venue_id, :null => false
      t.text :monday
      t.text :tuesday
      t.text :wednesday
      t.text :thursday
      t.text :friday
      t.text :saturday
      t.text :sunday
      t.boolean :approved, :null => false, :default => false
      t.string :type, :limit => 25, :null => false
    end
    add_index :specials, :venue_id
    add_index :specials, :type

    add_column :venues, :contact, :string, :limit => 100
    add_column :venues, :email, :string, :limit => 100
  end

  def down
    drop_table :specials
    remove_column :venues, :contact
    remove_column :venues, :email
  end
end
