module SubscriptionsHelper
  def frequencies_for_select
    Subscription::FREQUENCIES.map { |freq| [freq.titleize, freq] }
  end
end
