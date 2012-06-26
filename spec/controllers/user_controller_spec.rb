require 'spec_helper'

describe UserController do

  it "should be able to create a new user" do
    email = "tester@testing.com" 
    post :create, { :email => email, :password => "password" }
    response.header['Content-Type'].should include 'application/json'
    response.response_code.should eql 200
    result = User.new.from_json(response.body)
    result.email.should eql email
    result.authentication_token.nil?.should eql false
  end

  it "should return 409:conflict when creating a duplcate user" do
    email = "tester@testing.com"
    user = User.new(email: email, password: "password")
    user.save!
    post :create, { :email => email, :password => "password" }
    response.response_code.should eql 409
    result = ActiveSupport::JSON.decode(response.body)
    result["error"].should eql "Email already registered"
  end

  it "should be able to show a User" do
    user = FactoryGirl.create(:user)
    get :show, { :email => user.email, :password => user.password }
    response.response_code.should eql 200
    expected = user.to_json
    result = ActiveSupport::JSON.decode(response.body)
    result.should eql ActiveSupport::JSON.decode(expected)
  end

   it "should return 401 for unauthentic user" do
    user = FactoryGirl.create :user      
    get :show, { :email => user.email, :password => "Wrong Password" }
    response.response_code.should eql 401
    result = ActiveSupport::JSON.decode(response.body)
    result["error"].should eql I18n.t('request.unauthorized')
  end
end
