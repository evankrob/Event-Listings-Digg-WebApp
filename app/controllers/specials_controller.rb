class SpecialsController < ApplicationController
  before_filter :show_welcome!

  def index
    @venue = Venue.find_by_uri(params[:venue]) if params[:venue]
    @scope = "at #{@venue.name}" if @venue

    respond_to do |format|
      format.html do
        @specials = find_specials
        render :index
      end
      format.ajax { render :partial => 'table', :formats => %w(html), :locals => {:specials => find_specials} }
      format.json { render :json => find_specials }
    end
  end

  def show
    @special = Special.find(params[:id])
    page_title @special.venue.name

    respond_to do |format|
      format.html
      format.json { render :json => @special }
    end
  end

  private

  def find_specials
    SpecialSearch.new(params, klass).run.results
  end

  def klass
    @klass ||= self.class.name.sub(/Controller$/, '').singularize.constantize
  end
end
