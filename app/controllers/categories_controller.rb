class CategoriesController < ApplicationController
  before_filter :show_welcome!

  def show
    @category = Category.find_by_name(params[:name])
    raise ActiveRecord::RecordNotFound if @category.nil?

    @events = @category.events.approved.upcoming.with_associations
  end
end
