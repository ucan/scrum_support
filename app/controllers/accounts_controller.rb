class AccountsController < ApplicationController

  before_filter :authenticate

  # Returns a list of account ids
  def list
    user = user_from_auth_token
    accounts = user.accounts
    render :json => accounts
  end

  # Returns a list of projects for the user
  def show
    begin
      user = user_from_auth_token
      account = user.accounts.find(params[:id]) #required as a part of the route

      render :json => account.projects

    rescue ActiveRecord::RecordNotFound
      render :json => {:error => I18n.t('request.forbidden') }, :status => :forbidden
    end
  end


  def create
    # check if we are creating a pt account
    if params[:type] == "pivotal_tracker"
      user = user_from_auth_token
      token = params[:token]
      ptAccount = PtAccount.new(token)
      user.accounts << ptAccount
      user.save
    else
      # invalid type specified
      render :json => {:error => I18n.t('request.bad_request')}, :status => :bad_request
    end
  end
end
