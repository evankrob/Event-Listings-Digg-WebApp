class Venue < ActiveRecord::Base
  CITIES_MIN = 5

  has_many :events
  has_many :specials

  validates_presence_of :name, :city
  validates_uniqueness_of :name, :case_sensitive => false#, :scope => :city, :if => lambda { |venue| venue.zip? }
  validates_length_of :contact, :email, :maximum => 100, :allow_blank => true

  before_destroy :check_for_usage

  def self.find_by_uri(name)
    replace = name =~ /--/ ? '--' : '-'
    where('lower(name) = ?', name.gsub(replace, ' ').downcase).first
  end

  def self.cities
    select('distinct city').order('city').map(&:city).to_a
  end

  def self.major_cities
    select('city, count(events.id) as num_events').joins(:events).order('venues.city').group('venues.city').having("num_events >= #{CITIES_MIN}").map(&:city)
  end

  def self.minor_cities
    select('city, count(events.id) as num_events').joins(:events).order('venues.city').group('venues.city').having("num_events < #{CITIES_MIN}").map(&:city)
  end

  def address
    "#{street} #{city} #{zip}"
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def to_uri
    replacement = name =~ /[^\-]-[^\-]/ ? '--' : '-'
    name.gsub(' ', replacement)
  end

  private

  def check_for_usage
    num_events = events.count + specials.count
    if num_events == 0
      true
    else
      errors.add(:base, "'#{name}' cannot be deleted because it has #{num_events} events")
      false
    end
  end

  public

  def self.create_from_csv(row)
    venue = Venue.find_or_initialize_by_name(row['venue'])
    if venue.new_record?
      venue.street = row['street']
      venue.city = row['city']
      venue.state = row['state']
      venue.zip = row['zip']
      venue.url = row['venue_url']
      venue.phone = row['phone']
      venue.contact = row['contact'] unless row['contact'].blank?
      venue.email = row['email'] unless row['email'].blank?
      venue.approved = true
      venue.save
    end
    return venue
  end
end
