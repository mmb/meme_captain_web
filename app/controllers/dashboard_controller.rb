# Admin dashboard controller.
class DashboardController < ApplicationController
  def show
    head(:forbidden) unless admin?

    last_day = (Time.now - 24.hours)..Time.now

    calculate_gend_image(last_day)

    @src_images_last_24h = SrcImage.where(created_at: last_day).count

    @new_users_last_24h = User.where(created_at: last_day).count

    @no_result_searches = NoResultSearch.last(20).reverse

    set_jobs
  end

  private

  def calculate_gend_image(last_day)
    @gend_image_successes_last_24h = GendImage.where(
      error: nil, created_at: last_day
    ).count
    @gend_image_errors_last_24h = GendImage.where.not(error: nil).where(
      created_at: last_day
    ).count
    @gend_image_success_rate_last_24h = success_rate(
      @gend_image_successes_last_24h, @gend_image_errors_last_24h
    )
  end

  def success_rate(success_count, error_count)
    total = success_count + error_count
    return 100.00 if total <= 0
    (success_count / total.to_f * 100).round(2)
  end

  def set_jobs
    @jobs = Delayed::Job.where(attempts: 0).order(:created_at)
  end
end
