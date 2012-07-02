require 'spec_helper'
require 'account'
require 'user'

describe Account do
  before(:each) do
    @account = FactoryGirl.create(:account)
  end

  it "should not be valid without a user" do
    @account.user = nil
    @account.should have(1).error_on(:user)
  end

  it "Should be able to add a new ProjectMapping, and directly retrieve our project" do
    project = FactoryGirl.create(:project)
    external_project_link = FactoryGirl.create(:external_project_link, project: project)
    @account.external_project_links << external_project_link
    @account.save!
    @account.external_project_links.length.should eql 1
    @account.projects.should eql [project]
    @account.external_project_links[0].project.should eql project
  end

  it "should not be able to add a duplicate project_mapping" do
    project = FactoryGirl.create(:project)
    external_project_link = FactoryGirl.create(:external_project_link, project: project)
    account = external_project_link.accounts.first
    account.external_project_links.length.should eql 1
    account.projects.length.should eql 1
    account.external_project_links << external_project_link
    account.save!
    account.external_project_links.length.should eql 1
    account.projects.length.should eql 1
  end

  it "should raise a NotImplementedError on fetch_projects" do
    lambda { @account.fetch_projects }.should raise_error(NotImplementedError)
  end

  subject { @account }
  it { should respond_to(:user) }
  it { should respond_to(:external_project_links) }
  it { should respond_to(:projects) }
  it { should be_valid }
end
