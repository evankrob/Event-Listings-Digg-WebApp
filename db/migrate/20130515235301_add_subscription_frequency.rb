class AddSubscriptionFrequency < ActiveRecord::Migration
  def up
    add_column :subscriptions, :frequency, :string, :limit => 20
  end

  def down
    drop_column :subscriptions, :frequency
  end
end
