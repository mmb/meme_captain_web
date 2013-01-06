module ApplicationHelper

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def thumbnail(model)
    image_tag(
        url_for(model),
        :size => "#{model.width}x#{model.height}",
        :class => "thumb img-polaroid"
    )
  end

end
