class SubscriptionMailer < ActionMailer::Base
  add_template_helper ApplicationHelper
  add_template_helper EventsHelper
  add_template_helper OccurrencesHelper

  def upcoming(subscription)
    @subscription = subscription
    @host = "www.whatsupraleigh.com"

    mail(:to => subscription.email, :subject => "What's Up Raleigh Upcoming Events")
  end
end
