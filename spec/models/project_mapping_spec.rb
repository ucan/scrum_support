require 'spec_helper'

describe ProjectMapping do
  before(:each) do
  	user = User.new(name:"Testy")
  	account = Account.new
  	user.accounts << account
  	project = Project.new(title: "Test Project")
	@projectMapping = ProjectMapping.new(linked_id: 12345, project: project)
	account.project_mappings << @projectMapping
  end

  it "should not be valid without a linked_id" do
  	@projectMapping.linked_id = nil
  	@projectMapping.should have(1).error_on(:linked_id)
  	@projectMapping.should_not be_valid
  end

  it "should not be valid without a project" do
  	@projectMapping.project = nil
  	@projectMapping.should have(1).error_on(:project)
  	@projectMapping.should_not be_valid
  end

  it "should not be valid without an account" do
  	@projectMapping.account = nil
  	@projectMapping.should have(1).error_on(:account)
  	@projectMapping.should_not be_valid
  end

  subject { @projectMapping }
  it { should respond_to(:linked_id) }
  it { should respond_to(:project) }
  it { should respond_to(:account) }
  it { should be_valid }
end
