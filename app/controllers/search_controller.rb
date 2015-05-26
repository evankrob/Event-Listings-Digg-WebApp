class SearchController < ApplicationController
  before_filter :show_welcome!

  def quick
    respond_to do |format|
      format.json { render :json => {:events => EventSearch.new(params).run.results, :specials => SpecialSearch.new(params).run.results} }
    end
  end

  def new
    page_title 'Search'
    @search = {}
  end

  def show
    page_title 'Search'
    @search = params[:search] || {}
  end
end
