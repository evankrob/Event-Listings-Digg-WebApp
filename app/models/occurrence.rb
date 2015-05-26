class Occurrence < ActiveRecord::Base
  hack_datetime :starts_at, :ends_at

  belongs_to :event

  validates_presence_of :starts_at

  def as_json(options=nil)
    {:starts_at => starts_at, :ends_at => ends_at}
  end
end
