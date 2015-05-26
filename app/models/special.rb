class Special < ActiveRecord::Base
  DAYS = %w(monday tuesday wednesday thursday friday saturday sunday)
  HEADERS = %w(venue street city state zip phone venue_url contact email tags) + DAYS
  include TaggableWithProxy

  belongs_to :venue

  validates_presence_of :venue_id

  scope :today, lambda { where("specials.#{Date.today.strftime('%A').downcase} is not null") }
  scope :weekend, lambda { where("specials.friday is not null OR specials.saturday is not null OR specials.sunday is not null") }
  scope :approved, where(:approved => true)
  scope :with_associations, includes(:venue)

  def to_param
    "#{id}-#{venue.name.parameterize}"
  end

  def as_json(options=nil)
    {:id => id,
     :venue => venue.name,
     :city => venue.city,
     :days => days.map(&:capitalize),
     :link => to_path}
  end

  def each_day
    days.each do |day|
      yield day.capitalize, self.send(day) if block_given?
    end
  end

  private

  def days
    DAYS.map do |day|
      result = self.send(day)
      result.blank? ? nil : day
    end.compact
  end

  def to_path
    "/#{venue.city}/#{venue.to_uri}/specials/#{to_param}"
  end

  public

  def self.create_from_csv(row)
    venue = Venue.create_from_csv(row)
    return venue if venue.errors.any?

    special = self.find_or_initialize_by_venue_id(venue.id)
    special.tag_list = row['tags']
    DAYS.each do |day|
      special.send("#{day}=", row[day])
    end
    special.approved = true
    special.save

    return special
  end
end
