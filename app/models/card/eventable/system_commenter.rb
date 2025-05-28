class Card::Eventable::SystemCommenter
  attr_reader :card, :event

  def initialize(card, event)
    @card, @event = card, event
  end

  def comment
    return unless comment_body.present?

    card.comments.create! creator: User.system, body: comment_body, created_at: event.created_at
  end

  private
    def comment_body
      case event.action
      when "card_assigned"
        "#{event.creator.name} assigned this to #{event.assignees.pluck(:name).to_sentence}."
      when "card_unassigned"
        "#{event.creator.name} unassigned from #{event.assignees.pluck(:name).to_sentence}."
      when "card_staged"
        "#{event.creator.name} moved this to '#{event.stage_name}'."
      when "card_closed"
        "Closed as “#{ card.closure.reason }” by #{ event.creator.name }"
      when "card_title_changed"
        "#{event.creator.name} changed the title from '#{event.particulars.dig('particulars', 'old_title')}' to '#{event.particulars.dig('particulars', 'new_title')}'."
      end
    end
end
