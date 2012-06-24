require 'spec_helper'

describe UserController do

	it "should be able to create a new user" do
		post :create, {:name => "Testy", :format => :json}
		expected = User.new(name: "Testy").to_json 
		response.header['Content-Type'].should include 'application/json'
		result = User.new.from_json(response.body)
		result.name.should eql "Testy"
		result.authentication_token.nil?.should eql false 
	end 

	it "should be able to show a User" do
		user = User.new(name: "Testy Kills")
		user.save!
 
		get :show, { :auth_token => user.authentication_token }  

		expected = user.to_json
		result = ActiveSupport::JSON.decode(response.body)
		ActiveSupport::JSON.decode(expected).should eql result
	end
end
