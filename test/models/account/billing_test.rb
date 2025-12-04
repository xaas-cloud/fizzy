require "test_helper"

class Account::BillingTest < ActiveSupport::TestCase
  test "detect card limit exceeded" do
    # Paid plans are never limited
    accounts(:"37s").update_column(:cards_count, 1_000_000)
    assert_not accounts(:"37s").card_limit_exceeded?

    # Free plan under limit
    accounts(:initech).update_column(:cards_count, 999)
    assert_not accounts(:initech).card_limit_exceeded?

    # Free plan over limit
    accounts(:initech).update_column(:cards_count, 1001)
    assert accounts(:initech).card_limit_exceeded?
  end
end
