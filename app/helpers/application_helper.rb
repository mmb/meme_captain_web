# encoding: UTF-8

# Application helper.
module ApplicationHelper
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def cache_expires(length_of_time)
    # Sets both Expires and Cache-Control headers.
    headers['Expires'] = (Time.now + length_of_time).httpdate
    expires_in 1.week, public: true
  end
end
