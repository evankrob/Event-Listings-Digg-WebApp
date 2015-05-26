module EventsHelper
  def live_query_params
    query_params = params.to_hash
    query_params[:action_name] = action_name
    query_params.to_json
  end

  def occurrences_display(event)
    occurs = event.occurrences
    display = []

    display << pretty_start(occurs[0]) if occurs[0]
    display << pretty_start(occurs[1]) if occurs[1]
    display << pretty_start(occurs[-1]) if occurs.size > 2 and occurs[-1]
    display << "... #{occurs.size - 3} more times ..." if occurs.size > 3

    display.join('<br />').html_safe
  end

  def venue_display(event, host=nil)
    url = if host
      venue_url(event.venue.city, event.venue.to_uri, :host => host)
    else
      venue_path(event.venue.city, event.venue.to_uri)
    end
    "#{link_to event.venue.name, url}<br />#{event.venue.city}".html_safe
  end

  def approval_status(event)
    if event.approved? then
      "<span class='label label-info'>Approved</span>".html_safe
    else
      "<span class='label label-important'>Un-approved</span>".html_safe
    end

  end
end
