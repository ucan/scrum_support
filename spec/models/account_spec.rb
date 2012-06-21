require 'spec_helper'
require 'account'
require 'user'

describe Account do
  before(:each) do
	@account = Account.new
	user = User.new(name: "Testy McTested")
	user.accounts << @account
  end

  it "should not be valid without a user" do
  	@account.user = nil
  	@account.should have(1).error_on(:user)
  end

  it "Should be able to add a new ProjectMapping, and directly retrieve our project" do
  	project = Project.new(title: "Test Project")
  	projectMapping = ProjectMapping.new(linked_id: 12345, project: project)
  	@account.project_mappings << projectMapping
  	@account.save
  	@account.project_mappings.length.should eql 1
  	@account.projects.should eql [project]
	@account.project_mappings[0].project.should eql project 
  end

  it "should not be able to add a duplicate project_mapping" do
  	project = Project.new(title: "Test Project")
  	projectMapping = ProjectMapping.new(linked_id: 67890, project: project)
  	@account.project_mappings << projectMapping
  	@account.save
  	@account.project_mappings.length.should eql 1
  	@account.projects.length.should eql 1
  	@account.project_mappings << projectMapping
  	@account.save
	@account.project_mappings.length.should eql 1
  	@account.projects.length.should eql 1 
  end

  it "should raise a NotImplementedError on fetch_projects" do
  	lambda { @account.fetch_projects }.should raise_error(NotImplementedError)
  end

  subject { @account }
  it { should respond_to(:user) }
  it { should respond_to(:project_mappings) }
  it { should respond_to(:projects) }
  it { should be_valid }
end
