class SpecialSearch
  attr_reader :klass
  attr_reader :params
  attr_reader :results

  def initialize(params, klass = nil)
    @klass = klass || Special
    @params = params.with_indifferent_access
  end

  def run
    venue = Venue.find_by_uri(params[:venue]) if params[:venue]

    specials = klass.approved.with_associations
    specials = specials.where(:venue_id => venue.id) if venue
    specials = specials.limit(params[:limit]) if params[:limit]

    # Search by one attr
    if params[:q]
      specials = specials.joins(:venue)
      wheres, conditions = 'venues.name LIKE :q OR venues.city LIKE :q', {:q => "%#{params[:q]}%"}
      if tag = ActsAsTaggableOn::Tag.where('lower(name) = ?', params[:q].downcase).first
        specials = specials.joins('LEFT OUTER JOIN taggings on taggable_id = specials.id and taggable_type LIKE "%Special"')
        wheres << ' OR taggings.tag_id = :tag_id'
        conditions[:tag_id] = tag.id
      end
      specials = specials.where(wheres, conditions)

    elsif params[:tag]
      specials = specials.tagged_with(params[:tag])

    elsif params[:city]
      specials = specials.joins(:venue).where('venues.city LIKE ?', params[:city])

    elsif params[:action_name] == 'other'
      specials = specials.joins(:venue).where('venues.city IN (?)', Venue.minor_cities)

    elsif params[:action_name] == 'today'
      specials = specials.today

    elsif params[:action_name] == 'weekend'
      specials = specials.weekend

    # Full search
    elsif params[:search]
      specials = specials.joins(:venue)
      specials = specials.where('venues.name LIKE ?', "%#{params[:search][:venue]}%") if !params[:search][:venue].blank?
      specials = specials.tagged_with(params[:search][:tags]) if !params[:search][:tags].blank?
      if cities = params[:search][:cities]
        cities_where = cities.map { |c| 'venues.city LIKE ?' }.join(' OR ')
        specials = specials.where(cities_where, *cities)
      end
    end

    specials

    @results = specials.all

    self
  end
end
