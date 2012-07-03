class UserController < ApplicationController

  # Create a new user
  def create
    if User.where(email: params[:email]).first
      render json: { error: "Email already registered" }, status: :conflict
      return
    elsif params[:email].nil? || params[:password].nil? 
        render json: { error: "#{I18n.t('request.bad_request')}: Fields [email, password] are required."}, status: :bad_request
    else
      user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
      if user.save
        render json: { user: { auth_token: user.auth_token }, 
              links: { accounts: "/accounts", projects: "/projects" } }, status: :created
        return
      else
        render json: { error: "#{I18n.t('request.bad_request')}: user.errors" }, status: :bad_request
        return
      end
    end
  end

  # Return the auth_token for a user if supplied with correct email & password
  def show
    if params[:email].nil? || params[:password].nil?
      render json: {error: "#{I18n.t('request.bad_request')}: email and password required."}, status: :bad_request
    else
      user = User.where(email: params[:email]).first
      if user && user.authenticate(params[:password])
        render json: {user: { auth_token: user.auth_token }, links: {accounts: "/accounts", projects: "/projects"} }, status: :ok
        return
      else
        render json: {error: I18n.t('request.unauthorized') }, status: :unauthorized
        return
      end
    end
  end

end
