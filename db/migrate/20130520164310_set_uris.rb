class SetUris < ActiveRecord::Migration
  def up
    Event.find_each do |event|
      event.send :set_uri
      event.save!
    end
  end
end
