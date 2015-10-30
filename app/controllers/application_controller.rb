# encoding: UTF-8

# Application controller.
class ApplicationController < ActionController::Base
  protect_from_forgery

  def not_logged_in(notice = nil)
    return if current_user

    session[:return_to] = request.url
    redirect_to new_session_path, notice: notice
    true
  end

  def admin?
    current_user.try(:is_admin)
  end

  def cache_expires(length_of_time)
    # Sets both Expires and Cache-Control headers.
    headers['Expires'.freeze] = (Time.now + length_of_time).httpdate
    expires_in 1.week, public: true
  end

  include ApplicationHelper
end
