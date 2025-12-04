module SubscriptionsHelper
  def subscription_period_end_action(subscription)
    if subscription.to_be_canceled?
      "Ends"
    elsif subscription.canceled?
      "Ended"
    else
      "Renews"
    end
  end
end
