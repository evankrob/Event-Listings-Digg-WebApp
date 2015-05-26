class SubscriptionsController < ApplicationController
  before_filter :show_welcome!
  before_filter :set_subscription, :only => [:show, :destroy]

  def new
    page_title 'Subscribe'
    @search = params[:search] || {}
    @subscription = Subscription.new
    @subscription.search_params = @search
  end

  def show
  end

  def create
    @subscription = Subscription.new(params[:subscription])
    @search = params[:search]
    @search.delete(:tag_proxy)
    @subscription.search_params = @search

    if @subscription.save
      flash[:notice] = "Thanks for subscribing!"
      SubscriptionMailer.upcoming(@subscription).deliver if @subscription.events.any?
      redirect_to subscription_path(@subscription, :token => @subscription.token)
    else
      page_title 'Subscribe'
      @search = @subscription.search_params
      render 'new'
    end
  end

  def destroy
    @subscription.destroy
    flash[:notice] = "You have been unsubscribed"
    redirect_to '/'
  end

  private

  def set_subscription
    @subscription = Subscription.find_by_id_and_token(params[:id], params[:token])
    raise ActiveRecord::RecordNotFound if @subscription.nil?
  end
end
