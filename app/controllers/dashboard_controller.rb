# Admin dashboard controller.
class DashboardController < ApplicationController
  def show
    head(:forbidden) unless admin?

    last_day = (Time.now - 24.hours)..Time.now

    @gend_images_last_24h = GendImage.where(created_at: last_day).count

    @src_images_last_24h = SrcImage.where(created_at: last_day).count

    @new_users_last_24h = User.where(created_at: last_day).count
  end
end
