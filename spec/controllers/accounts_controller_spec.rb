require 'spec_helper'

describe AccountsController do
  it "should be able to list account ids for a user" do
    user = FactoryGirl.build(:user)
    FactoryGirl.create :account, :user => user
    FactoryGirl.create :account, :user => user

    get :list, { :auth_token => user.authentication_token }

    expected = user.accounts.to_json
    result = ActiveSupport::JSON.decode(response.body)
    ActiveSupport::JSON.decode(expected).should =~ result
  end

  it "can create an account linked to pivotal tracker" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  it "can show the information for a specific account" do
    account = FactoryGirl.create(:account)
    user = account.user
    
    get :show, {:id => account.id, :auth_token => user.authentication_token }

    expected = account.projects.to_json
    result = ActiveSupport::JSON.decode(response.body)
    ActiveSupport::JSON.decode(expected).should == result
  end

  it "does not allow access to other users accounts" do
    account1 = FactoryGirl.create :account
    user2 = FactoryGirl.create :user

    get :show, {:id => account1.id, :auth_token => user2.authentication_token }

    response.response_code.should eql 403
    result = ActiveSupport::JSON.decode(response.body)
    result["error"].should_not eql nil
    result["error"].should eql I18n.t('request.forbidden')

  end
  
  describe "create" do
    it "provides 400 error for invalid request" do
      user = FactoryGirl.create :user 
      
      post :create, {:auth_token => user.authentication_token}
      
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 400
      result["error"].should eql "#{I18n.t('request.bad_request')}: Invalid account type."
    end

    it "provides 400 error for pivotal tracker account type without email" do
      user = FactoryGirl.create :user      
      post :create, {:auth_token => user.authentication_token, :type => "pivotal_tracker", :password => "holycrap"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 400
      result["error"].should eql "#{I18n.t('request.bad_request')}: Email and password required."
    end

    it "provides 400 error for pivotal tracker account type without password" do
      user = FactoryGirl.create :user      
      post :create, {:auth_token => user.authentication_token, :type => "pivotal_tracker", :email => "yabababab@sdghkld.com"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 400
      result["error"].should eql "#{I18n.t('request.bad_request')}: Email and password required."
    end

    it "provides 401 error for incorrect email password combo" do
      user = FactoryGirl.create :user      
      post :create, {:auth_token => user.authentication_token, :type => "pivotal_tracker", 
        :email => "lordtestymctesticles@gmail.com", :password => "wrong password"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 401
    end

    it "returns 201 code and a " do
      user = FactoryGirl.create :user      
      post :create, {:auth_token => user.authentication_token, :type => "pivotal_tracker", 
        :email => "lordtestymctesticles@gmail.com", :password => "testicles"}
      result = ActiveSupport::JSON.decode(response.body)
      response.response_code.should eql 201
      response.location.should include "/accounts/"
    end
  end

end
