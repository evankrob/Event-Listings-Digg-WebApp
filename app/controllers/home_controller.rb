class HomeController < ApplicationController
  before_filter :show_welcome!

  def today
    @scope = 'today'
    page_title "Today's Events"

    respond_to do |format|
      format.html { render "events/index" }
    end
  end

  def weekend
    @scope = 'this weekend'
    page_title "This Weekend's Events"

    respond_to do |format|
      format.html { render "events/index" }
    end
  end

  def city
    @scope = "in #{params[:city]}"
    page_title "Events #{@scope}"

    respond_to do |format|
      format.html { render "events/index" }
    end
  end

  def other
    @scope = "in other cities"
    page_title "Events #{@scope}"

    respond_to do |format|
      format.html { render "events/index" }
    end
  end

  def about
    page_title 'About'
  end

  def contact
    page_title 'Contact Us'

    if request.post?
      if !params[:name].blank? and !params[:email].blank? and !params[:message].blank?
        ContactMailer.contact(params[:name], params[:email], params[:phone], params[:message]).deliver!
        flash[:notice] = "Your message has been sent. Thanks for your feedback!"
        redirect_to '/'
      else
        flash.now[:error] = "Please fill out all required fields"
        render 'contact'
      end
    else
      render 'contact'
    end
  end
end
