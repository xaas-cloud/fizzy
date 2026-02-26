class My::IdentitiesController < ApplicationController
  disallow_account_scope

  def show
    @identity = Current.identity
    @active_users = @identity.users.active
      .joins(:account)
      .merge(Account.active)
      .includes(:account)
  end
end
