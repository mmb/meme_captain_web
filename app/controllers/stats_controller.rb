# encoding: UTF-8

# Stats controller for sending arbitrary data to statsd from the web.
#
# The initial use case is deploy tracking.
class StatsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if authorized?
      StatsD.increment(params[:key])
      render(nothing: true)
    else
      render(nothing: true, status: :forbidden)
    end
  end

  private

  def authorized?
    !Rails.application.secrets.stats_secret.blank? &&
      Rails.application.secrets.stats_secret == params[:secret]
  end
end
