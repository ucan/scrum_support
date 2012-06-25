require 'spec_helper'

describe UserController do

	it "should be able to create a new user" do
		username = "tester"
    
    post :create, {:name => username, :format => :json}
    
		response.header['Content-Type'].should include 'application/json'
		result = User.new.from_json(response.body)
		result.name.should eql username
		result.authentication_token.nil?.should eql false 
	end 

	it "should be able to show a User" do
		user = FactoryGirl.create(:user)
 
		get :show, { :auth_token => user.authentication_token }  

		expected = user.to_json
		result = ActiveSupport::JSON.decode(response.body)
		ActiveSupport::JSON.decode(expected).should eql result
	end
end
