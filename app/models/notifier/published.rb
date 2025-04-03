class Notifier::Published < Notifier
  private
    def recipients
      bubble.watchers_and_subscribers(include_only_watching: true).without(creator)
    end
end
