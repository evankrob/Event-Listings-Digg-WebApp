class CreateSubscriptions < ActiveRecord::Migration
  def up
    create_table :subscriptions do |t|
      t.string :email, :null => false
      t.text :search_params
      t.string :token
      t.timestamps
    end
  end

  def down
    drop_table :subscriptions
  end
end
