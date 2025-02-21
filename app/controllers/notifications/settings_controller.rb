module Notifications
  class SettingsController < ApplicationController
    def show
      @buckets = Current.user.buckets.all
    end
  end
end
