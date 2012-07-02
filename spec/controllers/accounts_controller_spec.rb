require 'spec_helper'

describe AccountsController do

  include ActionController::HttpAuthentication::Token

  it "should be able to list account ids for a user" do
    user = FactoryGirl.build(:user)
    FactoryGirl.create(:account, user: user)

    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    get :list
 
    expected = user.accounts.to_json
    result = ActiveSupport::JSON.decode(response.body)
    result["accounts"].should =~ ActiveSupport::JSON.decode(expected)
  end

  it "can show the information for a specific account" do
    account = FactoryGirl.create(:account)
    user = account.user
    
    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    get :show, { id: account.id }

    expected = account.projects.to_json
    result = ActiveSupport::JSON.decode(response.body)
    result["projects"].should =~ ActiveSupport::JSON.decode(expected) 
  end

  it "does not allow access to other users accounts" do
    account1 = FactoryGirl.create :account
    user2 = FactoryGirl.create :user

    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user2.auth_token)
    get :show, {:id => account1.id }

    response.response_code.should eql 403
    result = ActiveSupport::JSON.decode(response.body)
    result["error"].should_not eql nil
    result["error"].should eql I18n.t('request.forbidden')

  end
  
  describe "create" do
    it "provides 400 error for invalid request" do
      user = FactoryGirl.create :user 
      
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      post :create
      
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 400
      result["error"].should eql "#{I18n.t('request.bad_request')}: Invalid account type."
    end

    it "provides 400 error for pivotal tracker account type without email (or api_token)" do
      user = FactoryGirl.create :user      
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      post :create, { :type => "pivotal_tracker", :password => "holycrap"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 400
      result["error"].should eql "#{I18n.t('request.bad_request')}: Either an api_token or email and password are required."
    end

    it "provides 400 error for pivotal tracker account type without password (or api_token)" do
      user = FactoryGirl.create :user   
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)  
      post :create, {:type => "pivotal_tracker", :email => "yabababab@sdghkld.com"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 400
      result["error"].should eql "#{I18n.t('request.bad_request')}: Either an api_token or email and password are required."
    end

    it "provides 401 error for incorrect email password combo" do
      user = FactoryGirl.create :user      
      @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
      post :create, {:type => "pivotal_tracker", :email => "lordtestymctesticles@gmail.com", :password => "wrong password"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 401
    end

    #it "provides 201 code and a link to the accounts base uri for a valid request using email and password" do
    #  user = FactoryGirl.create :user
    #  @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    #  post :create, {:type => "pivotal_tracker", :email => "lordtestymctesticles@gmail.com", :password => "testicles"}
    #  result = ActiveSupport::JSON.decode(response.body)
    #  response.response_code.should eql 201
    #  response.location.should include "/accounts/"
    #end

    #it "provides 201 code and a link to the accounts base uri for a valid request using api_token" do
    #  user = FactoryGirl.create :user    
    #  @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)  
    #  post :create, {:type => "pivotal_tracker", :api_token => 'c66fb689d2fe55512b1ce75ffab4b1d6'}
    #  result = ActiveSupport::JSON.decode(response.body)
    #  response.response_code.should eql 201
    #  response.location.should include "/accounts/"
    #end
  end

end
