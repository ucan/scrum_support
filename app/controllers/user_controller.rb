class UserController < ApplicationController

  #before_filter :authenticate, :only => :show

  # Create a new user
  def create
    if User.find_by_email(params[:email])
      render :json => {:error => "Email already registered"}, :status => :conflict
      return
    else
      user = User.new(email: params[:email], password: params[:password])
      if user.save
        render :json => user
        return
      else
        render :json => {:error => I18n.t('request.bad_request')}, :status => :bad_request
        return
      end
    end
  end

  # Return the auth_token for a user if supplied with correct email & password
  def show
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      render :json => user
      return
    else
      render :json => {:error => I18n.t('request.unauthorized') }, :status => :unauthorized
      return
    end
  end
end
