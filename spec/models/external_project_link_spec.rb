require 'spec_helper'

describe ExternalProjectLink do
  before(:each) do
    @account = FactoryGirl.create(:account)
    project = FactoryGirl.create(:project)
    @external_project_link = FactoryGirl.create(:external_project_link, project: project)
    @account.external_project_links << @external_project_link
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

  it "should trigger deletion of its project when it is deleted" do
    project = @external_project_link.project
    project.should_not eql nil
    lambda { project.reload }.should_not raise_error
    @external_project_link.destroy
    lambda { project.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should trigger deletion of its external_iteration_links when it is deleted" do
    eil1 = FactoryGirl.create(:external_iteration_link)
    eil2 = FactoryGirl.create(:external_iteration_link)
    @external_project_link.external_iteration_links << eil1 << eil2
    @external_project_link.external_iteration_links.count.should eql 2

    lambda { eil1.reload }.should_not raise_error
    lambda { eil2.reload }.should_not raise_error
    @external_project_link.destroy
    lambda { eil1.reload }.should raise_error(ActiveRecord::RecordNotFound)
    lambda { eil2.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should not allow duplicate external_tasks_links to be added" do
    eil = FactoryGirl.create(:external_iteration_link)
    @external_project_link.external_iteration_links << eil << eil
    @external_project_link.external_iteration_links.count.should eql 1
    @external_project_link.external_iteration_links.should eql [eil]
  end

  it "should have a unique {project, linked_id} pair" do
    project = @external_project_link.project
    linked_id = @external_project_link.linked_id
    duplicate = FactoryGirl.build(:external_project_link, project: project, linked_id: linked_id)
    duplicate.accounts << @account
    lambda { duplicate.save! }.should raise_error(ActiveRecord::RecordNotUnique)
  end

  subject { @external_project_link }
  it { should respond_to(:linked_id) }
  it { should respond_to(:project) }
  it { should respond_to(:accounts) }
  it { should be_valid }
end
