class TextileController < ApplicationController
  def preview
    cloth = RedCloth.new(params[:text].to_s)
    cloth.filter_html = true
    render :text => cloth.to_html
  end
end
