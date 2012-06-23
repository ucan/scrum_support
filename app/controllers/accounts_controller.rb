class AccountsController < ApplicationController

  before_filter :authorised?

  # Returns a list of account ids
  def list
    user = user_from_auth_token
    accounts = user.accounts
    render :json => accounts
  end

  # Returns a list of account ids for the user
  def show
    begin
      user = user_from_auth_token
      account = user.accounts.find(params[:id])

      render :json => account.projects

    rescue ActiveRecord::RecordNotFound
      render :json => {:error => I18n.t('request.forbidden') }, :status => 403 # Forbidden
    end
  end


  def create
    # check if we are creating a pt account
    if params[:type] == "pivotal_tracker"
      user = User.find(params[:userid])
      token = params[:token]
      @ptAccount = PtAccount.new(token)
      user.accounts << @ptAccount
      user.save
    else
      # invalid params
    end
  end
end
