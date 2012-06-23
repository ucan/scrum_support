require 'spec_helper'

describe ProjectsController do

	it "should return all the projects for a user" do
		user = User.new(name:"Garrrry")
		account1 = Account.new
		pm1 = ProjectMapping.new(linked_id: 12345, project: Project.new(title:"Test1"))
		account1.project_mappings << pm1
		account2 = Account.new
		pm2 = ProjectMapping.new(linked_id: 67890, project: Project.new(title:"Test2"))
		account2.project_mappings << pm2 
		user.accounts << account1 << account2
		user.save!

		get :list, { :auth_token => user.authentication_token } 
		result = ActiveSupport::JSON.decode(response.body)
		result.count.should eql 2 
		result.should =~ ActiveSupport::JSON.decode([pm1.project, pm2.project].to_json)
	end

	it "should return a list of stories for a project" do
		user = User.new(name:"Garrrry")
		account1 = Account.new
		project = Project.new(title:"Test1")
		pm1 = ProjectMapping.new(linked_id: 12345, project: project)
		account1.project_mappings << pm1
		project.stories << Story.new(title: "ullo")
		project.stories << Story.new(title: "ouch")
		user.accounts << account1
		user.save!

		get :show, {:id => project.id, :auth_token => user.authentication_token } 	
		result = ActiveSupport::JSON.decode(response.body)
		result.count.should eql 2 
		result.should =~ ActiveSupport::JSON.decode(project.stories.to_json)
	end

	it "should only allow access to the authenticated users stories" do
		user = User.new(name:"Garrrry")
		account1 = Account.new
		project = Project.new(title:"Test1")
		pm1 = ProjectMapping.new(linked_id: 12345, project: project)
		account1.project_mappings << pm1
		project.stories << Story.new(title: "ullo")
		user.accounts << account1
		user.save!

		notGarry = User.new(name: "Not Garrrry")
		notGarry.save!

		get :show, {:id => project.id, :auth_token => notGarry.authentication_token }
		result = ActiveSupport::JSON.decode(response.body)
		result["error"].should_not eql nil
    	result["error"].should eql I18n.t('request.forbidden')
	end
end
