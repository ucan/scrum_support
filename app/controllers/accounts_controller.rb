class AccountsController < ApplicationController

  before_filter :authenticate

  # Returns a list of account ids
  def list
    user = current_user
    accounts = user.accounts
    render :json => accounts
  end

  # Returns a list of projects for the user
  def show
    begin
      user = current_user
      account = user.accounts.find(params[:id]) #required as a part of the route

      render :json => account.projects

    rescue ActiveRecord::RecordNotFound
      render :json => {:error => I18n.t('request.forbidden') }, :status => :forbidden
    end
  end

  def create
    errors = ""
    # check if we are creating a pt account
    if params[:type] == "pivotal_tracker"
      if params[:email].nil? || params[:password].nil?
        errors << "Email and password required."
      else
        create_pivotal_tracker
        return
      end
    else
      errors << "Invalid account type."
    end
    # invalid type specified
    render :json => {:error => "#{I18n.t('request.bad_request')}: #{errors}"}, :status => :bad_request
  end


  protected

  def create_pivotal_tracker
    begin
      ptAccount = PtAccount.new(params[:email], params[:password])
      user = current_user
      user.accounts << ptAccount
      if (ptAccount.save!)
        render :json => ptAccount, :status => :created, :location => url_for(controller: :accounts, action: :show, id: ptAccount.id)
        return
      else
        render :json => {:error => "#{I18n.t('request.bad_request')}: #{ptAccount.errors}"}, :status => :bad_request
      end
    rescue RestClient::Unauthorized
      render :json => {:error => "#{I18n.t('request.unauthorized')}: Incorrect email or password"}, :status => :unauthorized
    end
  end

end
