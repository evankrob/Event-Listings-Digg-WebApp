class EventsController < ApplicationController
  before_filter :show_welcome!

  def index
    @venue = Venue.find_by_uri(params[:venue]) if params[:venue]
    @scope = "at #{@venue.name}" if @venue
    @city = params[:city]

    respond_to do |format|
      format.html do
        @events = find_events
        render :index
      end
      format.ajax { render :partial => 'table', :formats => %w(html), :locals => {:events => find_events} }
      format.json { render :json => find_events }
    end
  end

  def show
    @event = Event.find(params[:id])
    page_title @event.name

    respond_to do |format|
      format.html
      format.json { render :json => @event }
    end
  end

  def new
    # @venue_names = Venue.uniq.pluck(:name)
    @event = Event.new
    @event.occurrences.build
    @venues = Venue.all
    @categories = Category.all
    page_title 'Submit an Event'

    respond_to do |format|
      format.html
      format.json { render :json => @event }
    end
  end

  def create
    @event = Event.new(params[:event])
    @event.approved = false

    respond_to do |format|
      if @event.save
        format.html { redirect_to venue_event_path(@event.venue.city, @event.venue, @event), :notice => 'Event was successfully submitted.' }
        format.json { render :json => @event, :status => :created, :venue => @event }
      else
        @venues = Venue.all
        @categories = Category.all
        format.html { render :action => "new" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def find_events
    EventSearch.new(params).run.results
  end
end
