class VenuesController < ApplicationController
  before_filter :show_welcome!

  def index
    @venues = Venue.all

    respond_to do |format|
      format.html
      format.json { render :json => @venues }
    end
  end

  def show
    @venue = Venue.find_by_uri(params[:venue])
    raise ActiveRecord::RecordNotFound if @venue.nil?
    page_title "Events at #{@venue.name}"
    @events = @venue.events.approved.upcoming.with_associations

    respond_to do |format|
      format.html
      format.json { render :json => @venue }
    end
  end

  def events
    @venue = Venue.find_by_uri(params[:venue])
    raise ActiveRecord::RecordNotFound if @venue.nil?

    @events = EventSearch.new(params).run.results
  end

  def specials
    @venue = Venue.find_by_uri(params[:venue])
    raise ActiveRecord::RecordNotFound if @venue.nil?

    @specials = SpecialSearch.new(params).run.results
  end
end
