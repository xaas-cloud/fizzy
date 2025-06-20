class Prompts::Collections::UsersController < ApplicationController
  include CollectionScoped

  def index
    @users = @collection.users
    render layout: false
  end
end
