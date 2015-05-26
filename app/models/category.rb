class Category < ActiveRecord::Base
  has_many :events

  validates_presence_of :name
  validates_uniqueness_of :name

  before_destroy :check_for_usage

  def to_s
    name
  end

  private

  def check_for_usage
    num_events = events.count
    if num_events == 0
      true
    else
      errors.add(:base, "'#{name}' cannot be deleted because it is being used by #{num_events} events")
      false
    end
  end
end
