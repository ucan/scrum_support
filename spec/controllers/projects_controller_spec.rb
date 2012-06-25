require 'spec_helper'

describe ProjectsController do

	it "should return all the projects for a user" do
    project1 = FactoryGirl.create :project
    account1 = project1.account
    user = account1.user
		account2 = FactoryGirl.create :account, :user => user
    pm = FactoryGirl.build :project_mapping, :account => account2
    project2 = FactoryGirl.create :project, :project_mapping => pm

		get :list, { :auth_token => user.authentication_token } 
		result = ActiveSupport::JSON.decode(response.body)
		result.count.should eql 2 
		result.should =~ ActiveSupport::JSON.decode([project1, project2].to_json)
	end

	it "should return a list of stories for a project" do
    project = FactoryGirl.create :project
    user = project.account.user
		project.stories << Story.new(title: "ullo")
		project.stories << Story.new(title: "ouch")

		get :show, {:id => project.id, :auth_token => user.authentication_token } 	
		result = ActiveSupport::JSON.decode(response.body)
		result.count.should eql 2 
		result.should =~ ActiveSupport::JSON.decode(project.stories.to_json)
	end

  it "should provide an error if the project id is not valid" do
    user = FactoryGirl.create :user
    get :show, { :id => 999999, :auth_token => user.authentication_token }
    result = ActiveSupport::JSON.decode response.body
    response.status.should eql 404
    result["error"].should eql I18n.t 'request.not_found'
  end

	it "should only allow access to the authenticated users stories" do
		story = FactoryGirl.create :story
    project = story.project
    
		different_user = FactoryGirl.create :user 

		get :show, {:id => project.id, :auth_token => different_user.authentication_token }
		result = ActiveSupport::JSON.decode(response.body)
		result["error"].should_not eql nil
    	result["error"].should eql I18n.t('request.forbidden')
	end
end
