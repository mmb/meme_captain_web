class SessionController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, :notice => 'Signed in.'
    else
      flash[:error] = 'Login failed.'
      render :new
    end
  end

  def destroy
    session.delete :user_id
  end

end
