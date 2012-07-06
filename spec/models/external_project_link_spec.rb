require 'spec_helper'

describe ExternalProjectLink do
  before(:each) do
    account = FactoryGirl.create(:account)
    project = FactoryGirl.create(:project)
    @external_project_link = FactoryGirl.create(:external_project_link, project: project)
    account.external_project_links << @external_project_link
  end

  it "should not be valid without a linked_id" do
    @external_project_link.linked_id = nil
    @external_project_link.should have(1).error_on(:linked_id)
    @external_project_link.should_not be_valid
  end

  it "should not be valid without a project" do
    @external_project_link.project = nil
    @external_project_link.should have(1).error_on(:project)
    @external_project_link.should_not be_valid
  end

  it "should not be valid without an account" do
    @external_project_link.accounts = []
    @external_project_link.should_not be_valid
    @external_project_link.should have(1).error_on(:accounts)

  end

  subject { @external_project_link }
  it { should respond_to(:linked_id) }
  it { should respond_to(:project) }
  it { should respond_to(:accounts) }
  it { should be_valid }
end
