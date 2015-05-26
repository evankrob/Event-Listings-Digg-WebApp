class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag
    @tags = @tags.where("tags.name LIKE ?", "%#{params[:q]}%") if params[:q]
    @tags = @tags.all

    respond_to do |format|
      format.json do
        render :json => @tags.map(&:name).to_json
      end
    end
  end

  def show
    @tag = params[:tag]
    @scope = "tagged as '#{@tag}'"
    page_title @tag

    render "events/index"
  end
end
