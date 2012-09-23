class AccountsController < ApplicationController

  before_filter :authenticate

  # Returns all the users accounts (basic details)
  def list
    if current_user
      accounts = current_user.accounts
      render json: { accounts: accounts }, status: :ok
    else
      render json: { error: I18n.t('request.forbidden') }, status: :forbidden
    end
  end

  # Returns a list of projects for one of the users accounts
  def show
    begin
      account = current_user.accounts.find(params[:id]) #required as a part of the route
      if (account)
        account.fetch_projects
        account.reload
        json = account.as_json
        json["projects"] = account.projects
        render json: { account: json }, status: :ok
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: I18n.t('request.forbidden') }, status: :forbidden
    end
  end

  # Returns a newly created account (including all projects for that account)
  def create
    errors = ""
    # check if we are creating a pt account
    if params[:type] == "PtAccount"
      if (params[:email].nil? || params[:password].nil?) # TODO login using email & api? params[:api_token].nil?
        errors << "An email and password are required."
      else
        create_pivotal_tracker
        return
      end
    else
      errors << "Invalid account type: #{params[:type] || 'missing'}. Valid options include: PtAccount"
    end
    # invalid type specified
    render json: { error: "#{I18n.t('request.bad_request')}: #{errors}"}, status: :bad_request
  end


  protected

  # TODO should creating an account return all the projects accounts, or just the accounts basic details?
  def create_pivotal_tracker
    begin      
      api_token = PtAccount.get_token(params[:email], params[:password])
      ptAccount = PtAccount.new(api_token: api_token, email: params[:email])
      current_user.accounts << ptAccount
      if (ptAccount.save)
        ptAccount.fetch_projects
        ptAccount.reload
        json = ptAccount.as_json
        json["projects"] = ptAccount.projects
        render json: { account: json }, status: :created
        return
      else
        # TODO Return 403 forbidden if account already exists
        render json: { error: "#{I18n.t('request.bad_request')}: #{ptAccount.errors.full_messages}"}, status: :bad_request
      end
    rescue RestClient::Unauthorized
      render json: { error: "#{I18n.t('request.unauthorized')}: Incorrect email or password"}, status: :unauthorized
    end
  end

end
