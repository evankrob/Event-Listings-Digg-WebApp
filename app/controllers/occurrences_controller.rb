class OccurrencesController < InheritedResources::Base
  def create
    @event = Event.find(params[:event_id])
    @occurrence = @event.occurrences.build(params[:occurrence])

    respond_to do |format|
      if @occurrence.save
        format.html { redirect_to venue_event_path(@event.venue.city, @event.venue, @event), :notice => 'Thanks for the update!' }
      else
        @venues = Venue.all
        @categories = Category.all
        format.html { render :action => "events/show" }
      end
    end
  end
end
