class Notifier::Assigned < Notifier
  private
    def recipients
      event.assignees.excluding(bubble.bucket.access_only_users)
    end
end
