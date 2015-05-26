class EventSearch
  attr_reader :params
  attr_reader :results

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def run
    venue = Venue.find_by_uri(params[:venue]) if params[:venue]

    events = venue ? venue.events : Event
    events = events.approved.upcoming.with_associations
    events = events.limit(params[:limit]) if params[:limit]

    # Search by one attr
    if params[:q]
      events = events.joins(:venue)
      wheres, conditions = 'events.name LIKE :q OR venues.name LIKE :q OR venues.city LIKE :q', {:q => "%#{params[:q]}%"}
      if tag = ActsAsTaggableOn::Tag.where('lower(name) = ?', params[:q].downcase).first
        events = events.joins('LEFT OUTER JOIN taggings on taggable_id = events.id and taggable_type = "Event"')
        wheres << ' OR taggings.tag_id = :tag_id'
        conditions[:tag_id] = tag.id
      end
      events = events.where(wheres, conditions)

    elsif params[:tag]
      events = events.tagged_with(params[:tag])

    elsif params[:city]
      events = events.joins(:venue).where('venues.city LIKE ?', params[:city])

    elsif params[:action_name] == 'other'
      events = events.joins(:venue).where('venues.city IN (?)', Venue.minor_cities)

    elsif params[:action_name] == 'today'
      time_range = Time.now.midnight..(Time.now.midnight + 1.day )
      events = events.joins(:occurrences).where(:occurrences => {:starts_at => time_range})

    elsif params[:action_name] == 'weekend'
      time_range = (Time.now.beginning_of_week + 4.days)..Time.now.end_of_week
      events = events.joins(:occurrences).where(:occurrences => {:starts_at => time_range})

    # Full search
    elsif params[:search]
      events = events.joins(:venue).joins(:occurrences)
      events = events.where('events.name LIKE ?', "%#{params[:search][:event]}%") if !params[:search][:event].blank?
      events = events.where('venues.name LIKE ?', "%#{params[:search][:venue]}%") if !params[:search][:venue].blank?
      events = events.tagged_with(params[:search][:tags]) if !params[:search][:tags].blank?
      events = events.where('events.created_at >= ?', params[:search][:created_since]) if params[:search][:created_since]
      if cities = params[:search][:cities]
        cities_where = cities.map { |c| 'venues.city LIKE ?' }.join(' OR ')
        events = events.where(cities_where, *cities)
      end
      if categories = params[:search][:categories]
        events = events.where('events.category_id IN (?)', categories)
      end

      dates = []
      dates << params[:search][:start_date] unless params[:search][:start_date].blank?
      dates << params[:search][:end_date] unless params[:search][:end_date].blank?
      if dates.any?
        dates.map! { |d| DateTime.strptime(d, '%m/%d/%Y') } # Should really by Time.strptime (Ruby 1.8 issue)
        dates << (dates.first.to_date.+(1).to_time-1 ) if dates.size < 2
        events = events.where('occurrences.starts_at BETWEEN ? AND ?', *dates)
      end
    end

    @results = events.all

    self
  end
end
