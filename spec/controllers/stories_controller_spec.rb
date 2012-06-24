require 'spec_helper'

describe StoriesController do

	it "should allow a user to retrieve a list of tasks for one of their stories" do
		user = User.new(name:"Arnold")
		account = Account.new
		user.accounts << account

		project = Project.new(title:"Test1")		
		pm1 = ProjectMapping.new(linked_id: 12345, project: project)
		account.project_mappings << pm1		

		story = Story.new(title: "Write stories controller tests")
		project.stories << story
		story.tasks << Task.new(description: "Try something", status: "done")
		story.tasks << Task.new(description: "Curse a bit...or a lot", status: "started")
		story.tasks << Task.new(description: "Just go get drunk", status: "blocked")
		user.save!
		
		get :show, {:id => story.id, :auth_token => user.authentication_token } 	
		result = ActiveSupport::JSON.decode(response.body)
		result.should =~ ActiveSupport::JSON.decode(story.tasks.to_json)
	end
end
