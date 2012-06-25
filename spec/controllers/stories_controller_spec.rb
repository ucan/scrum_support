require 'spec_helper'

describe StoriesController do

	it "should allow a user to retrieve a list of tasks for one of their stories" do
    story = FactoryGirl.create :story
    FactoryGirl.create :task, :story => story
    FactoryGirl.create :task, :story => story
    FactoryGirl.create :task, :story => story 
    user = story.project.account.user

		get :show, {:id => story.id, :auth_token => user.authentication_token } 	
		
    result = ActiveSupport::JSON.decode(response.body)
		result.should =~ ActiveSupport::JSON.decode(story.tasks.to_json)
	end

  it "handles and id that is not associated with a story" do
    user = FactoryGirl.create :user

    get :show, { :id => 1, :auth_token => user.authentication_token }

    result = ActiveSupport::JSON.decode(response.body)
    response.status.should eql 404
    result["error"].should eql "Requested resource cannot be found"

  end
end
