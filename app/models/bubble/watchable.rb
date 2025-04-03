module Bubble::Watchable
  extend ActiveSupport::Concern

  included do
    has_many :watches, dependent: :destroy
    has_many :watchers, -> { merge(Watch.watching) }, through: :watches, source: :user

    after_create :set_watching_for_creator
  end

  def watched_by?(user)
    watchers_and_subscribers(include_only_watching: true).include?(user)
  end

  def set_watching(user, watching)
    watches.where(user: user).first_or_create.update!(watching: watching)
  end

  def watchers_and_subscribers(include_only_watching: false)
    involvements = include_only_watching ? [ :watching, :everything ] : :everything
    subscribers = bucket.users.where(accesses: { involvement: involvements })

    User.where(id: subscribers.pluck(:id) +
      watches.watching.pluck(:user_id) - watches.not_watching.pluck(:user_id))
  end

  private
    def set_watching_for_creator
      set_watching(creator, true)
    end
end
