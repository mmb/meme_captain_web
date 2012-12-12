class SessionsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, :notice => 'Logged in.'
    else
      flash[:error] = 'Login failed.'
      render :new
    end
  end

  def destroy
    if session[:user_id]
      session.delete :user_id

      redirect_to root_url, :notice => 'Logged out.'
    else
      redirect_to root_url
    end
  end

end
