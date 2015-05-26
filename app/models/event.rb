class Event < ActiveRecord::Base
  HEADERS = %w(event event_url description category tags venue street city state zip phone venue_url starts_at ends_at)
  include TaggableWithProxy

  belongs_to :venue
  belongs_to :category
  has_many :occurrences, :dependent => :destroy, :order => 'starts_at'

  validates_presence_of :venue_id, :category_id, :name, :description
  validate :has_a_valid_venue_name

  accepts_nested_attributes_for :occurrences

  scope :upcoming, lambda { joins(:occurrences).where('occurrences.starts_at >= ?', Date.today.to_time.utc).order('occurrences.starts_at ASC') }
  scope :approved, where( {:approved => true} )
  scope :unapproved, where( {:approved => false} )
  scope :with_associations, includes(:venue, :category, :occurrences)

  before_save :set_html_description
  before_save :set_uri

  def to_s
    name
  end

  def to_param
    "#{id}-#{self.uri}"
  end

  def as_json(options=nil)
    next_date = next_occurrence.try(:starts_at).try(:to_date)
    next_date = next_date.strftime("%a, %B %e#{' %Y' unless next_date.year == Date.today.year}") if next_date
    {:id => id, :name => name, :venue => venue.name, :city => venue.city, :category => category.name, :next_date => next_date, :link => to_path}
  end

  def next_occurrence
    occurrences.sort_by(&:starts_at).detect { |occurrence| occurrence.starts_at >= Date.today.to_time }
  end

  def venue_name
    venue.name if venue
  end

  def venue_name=(v_name)
    @venue_name = v_name
    self.venue = Venue.find_by_name(@venue_name)
  end

  private

  def to_path
    "/#{venue.city}/#{venue.to_uri}/events/#{to_param}"
  end

  def has_a_valid_venue_name
    if venue.nil? and !@venue_name.nil?
      self.errors.add(:base, "'#{@venue_name}' is not a valid venue")
    end
  end

  def set_html_description
    if self.description?
      cloth = RedCloth.new(self.description)
      cloth.filter_html = true
      self.html_description = cloth.to_html
    else
      self.html_description = nil
    end
  end

  def set_uri
    if self.uri.blank? and self.name
      self.uri = self.name.parameterize
    end
  end

  public

  def self.create_from_csv(row)
    venue = Venue.create_from_csv(row)
    return venue if venue.errors.any?

    category = Category.find_or_initialize_by_name(row['category'])
    if category.new_record?
      return category unless category.save
    end

    event = Event.find_or_initialize_by_venue_id_and_name(venue.id, row['event'])
    if event.new_record?
      event.category_id = category.id
      event.description = row['description']
      event.url = row['event_url']
      event.approved = true
      event.tag_list = row['tags'] unless row['tags'].blank?
      return event unless event.save
    end

    occurrence_starts_at = DateTime.strptime(CSVImport.normalize_date(row['starts_at'].to_s), '%m/%d/%Y %H:%M:%S %Z') rescue nil
    occurrence_ends_at = DateTime.strptime(CSVImport.normalize_date(row['ends_at'].to_s), '%m/%d/%Y %H:%M:%S %Z') rescue nil
    occurrence = event.occurrences.build(:starts_at => occurrence_starts_at, :ends_at => occurrence_ends_at)
    return occurrence unless occurrence.save

    return event
  end
end
