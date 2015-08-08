# encoding: UTF-8

# Sessions controller.
class SessionsController < ApplicationController
  def create
    user = User.auth_case_insens(params[:email], params[:password])

    if user
      login(user)
    else
      flash[:error] = 'Login failed.'.freeze
      render :new
    end
  end

  def destroy
    if session[:user_id]
      session.delete :user_id

      redirect_to root_url, notice: 'Logged out.'.freeze
    else
      redirect_to root_url
    end
  end

  private

  def login(user)
    session[:user_id] = user.id
    return_to = session.delete(:return_to)
    redirect_to(return_to || my_url, notice: 'Logged in.'.freeze)
  end
end
