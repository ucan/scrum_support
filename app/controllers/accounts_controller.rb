class AccountsController < ApplicationController

  before_filter :authenticate

  # Returns a list of account ids
  def list
    accounts = current_user.accounts
    render json: { accounts: accounts, links: {} }, status: :ok # TODO links
  end

  # Returns a list of projects for one of the users accounts
  def show
    begin
      # TODO fetch_projects
      account = current_user.accounts.find(params[:id]) #required as a part of the route
      render json: {projects: account.projects, links: {} }, status: :ok # TODO links

    rescue ActiveRecord::RecordNotFound
      render json: {error: I18n.t('request.forbidden') }, status: :forbidden
    end
  end

  def create
    errors = ""
    # check if we are creating a pt account
    if params[:type] == "PtAccount"
      if params[:api_token].nil? && (params[:email].nil? || params[:password].nil?)
        errors << "Either an api_token or email and password are required."
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

  def create_pivotal_tracker
    begin
      api_token = if params[:api_token]
        params[:api_token]
      else
        PtAccount.get_token(params[:email], params[:password])
      end
      ptAccount = PtAccount.new(api_token: api_token, email: params[:email])
      current_user.accounts << ptAccount
      if (ptAccount.save)        
        # TODO do we need to add links to 'created', and 'error' responses?
        render json: { id: ptAccount.id, type: ptAccount.type, api_token: ptAccount.api_token }, :status => :created,
                      :location => url_for(controller: :accounts, action: :show, id: ptAccount.id)
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
