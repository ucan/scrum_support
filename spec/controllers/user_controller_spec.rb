require 'spec_helper'

describe UserController do

  describe "Create" do

    it "should be able to create a new user" do
      email = "tester@testing.com"
      password = "password"
      post :create, { :email => email, :password => password, :password_confirmation => password }
      response.header['Content-Type'].should include 'application/json'
      response.response_code.should eql 201
      result = ActiveSupport::JSON.decode(response.body) #User.new.from_json(response.body)
      result["user"]["email"].should eql email
      result["user"]["auth_token"].nil?.should eql false
    end

    it "should return 400:bad request when creating a new user with non-matching passwords" do
      email = "tester@testing.com"
      password = "password"
      post :create, { :email => email, :password => password, :password_confirmation => "not password" }
      response.response_code.should eql 400
      result = ActiveSupport::JSON.decode(response.body)
      result["error"].should eql "#{I18n.t('request.bad_request')}: Passwords do not match."
    end

    it "should return 409:conflict when creating a duplicate user" do
      email = "tester@testing.com"
      user = User.new(email: email, password: "password")
      user.save!
      post :create, { :email => email, :password => "password" }
      response.response_code.should eql 409
      result = ActiveSupport::JSON.decode(response.body)
      result["error"].should eql "Email already registered"
    end
  end

  describe "Show" do

    it "should be able to show a User" do
      user = FactoryGirl.create(:user)
      get :show, { :email => user.email, :password => user.password }
      response.response_code.should eql 200
      expected = user.to_json
      result = ActiveSupport::JSON.decode(response.body)
      result["user"].should eql ActiveSupport::JSON.decode(expected)
    end

    it "should return 400 if neither email nor password is supplied" do
      user = FactoryGirl.create :user      
      get :show
      response.response_code.should eql 400
      result = ActiveSupport::JSON.decode(response.body)
      result["error"].should eql "#{I18n.t('request.bad_request')}: email and password required."
    end

    it "should return 400 if email is not supplied" do
      user = FactoryGirl.create :user      
      get :show, { :password => user.password }
      response.response_code.should eql 400
      result = ActiveSupport::JSON.decode(response.body)
      result["error"].should eql "#{I18n.t('request.bad_request')}: email and password required."
    end

    it "should return 400 if password is not supplied" do
      user = FactoryGirl.create :user      
      get :show, { :email => user.email }
      response.response_code.should eql 400
      result = ActiveSupport::JSON.decode(response.body)
      result["error"].should eql "#{I18n.t('request.bad_request')}: email and password required."
    end

    it "should return 401 for unauthentic user" do
      user = FactoryGirl.create :user      
      get :show, { :email => user.email, :password => "Wrong Password" }
      response.response_code.should eql 401
      result = ActiveSupport::JSON.decode(response.body)
      result["error"].should eql I18n.t('request.unauthorized')
    end
  end

end
