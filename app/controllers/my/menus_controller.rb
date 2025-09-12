class My::MenusController < ApplicationController
  include FilterScoped

  def show
    fresh_when @user_filtering
  end
end
