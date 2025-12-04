class Account::Subscription < ApplicationRecord
  belongs_to :account

  enum :status, %w[ active past_due unpaid canceled incomplete incomplete_expired trialing paused ].index_by(&:itself)

  validates :plan_key, presence: true, inclusion: { in: Plan::PLANS.keys.map(&:to_s) }

  def plan
    Plan.find(plan_key)
  end

  def paid?
    !plan.free? && active?
  end

  def to_be_canceled?
    active? && cancel_at.present?
  end
end
