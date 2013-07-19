# encoding: UTF-8

class SessionsController < ApplicationController

  def create
    user = User.auth_case_insens(params[:email], params[:password])

    if user
      session[:user_id] = user.id

      if session[:return_to]
        return_to = session[:return_to]
        session[:return_to] = nil
      else
        return_to = nil
      end

      redirect_to(return_to || my_url, notice: 'Logged in.')
    else
      flash[:error] = 'Login failed.'
      render :new
    end
  end

  def destroy
    if session[:user_id]
      session.delete :user_id

      redirect_to root_url, notice: 'Logged out.'
    else
      redirect_to root_url
    end
  end

end
