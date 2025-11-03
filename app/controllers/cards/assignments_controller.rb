class Cards::AssignmentsController < ApplicationController
  include CardScoped

  def new
    @users = @collection.users.active.alphabetically
    fresh_when @users
  end

  def create
    @card.toggle_assignment @collection.users.active.find(params[:assignee_id])
    render turbo_stream: turbo_stream.replace([ @card, :meta ], partial: "/cards/display/perma/meta", method: "morph", locals: { card: @card.reload })
  end
end
