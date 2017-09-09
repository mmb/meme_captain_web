# frozen_string_literal: true

# Application controller.
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate

  attr_reader :current_user

  helper_method :current_user

  def not_logged_in(notice = nil)
    return if current_user

    session[:return_to] = request.url
    redirect_to new_session_path, notice: notice
    true
  end

  def admin?
    current_user.try(:is_admin) ? true : false
  end

  def cache_expires(length_of_time)
    # Sets both Expires and Cache-Control headers.
    headers['Expires'] = (Time.zone.now + length_of_time).httpdate
    expires_in(length_of_time, public: true)
  end

  def remote_ip
    request.headers['CF-Connecting-IP'] || request.remote_ip
  end

  private

  def authenticate
    authenticate_with_http_token do |token|
      @current_user = User.find_by(api_token: token)
      head(:unauthorized) unless @current_user
      return
    end

    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
