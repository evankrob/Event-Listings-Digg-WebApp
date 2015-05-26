class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :page_title

  def page_title(title=nil)
    @page_title = title if title
    @page_title
  end

  def show_welcome!
    unless cookies[:skip_welcome]
      flash.now[:welcome] = Wur::CONFIG['welcome']
    end
  end
end
