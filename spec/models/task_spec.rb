require 'spec_helper'
require 'story'
require 'project'

describe Task do

  before(:each) do
    @story = FactoryGirl.create(:story)
    @task = FactoryGirl.build(:task, story: @story)
  end

  it "should not be valid without a description" do
    @task.description = nil
    @task.should have(1).error_on(:description)
    @task.should_not be_valid
  end

  it "should not be valid without a story" do
    @task.story = nil
    @task.should have(1).error_on(:story)
    @task.should_not be_valid
  end

  it "should have a valid default status" do
    @task.status.should eql nil
    @task.valid?
    @task.should be_valid
    @task.not_started?.should eql true
  end

  it "should be able to change its status" do
    @task.valid?
    @task.not_started?.should eql true
    @task.start
    @task.started?.should eql true
    @task.block
    @task.blocked?.should eql true
    @task.completed?.should eql false
    @task.complete
    @task.completed?.should eql true
  end

  it "should be able to have a TeamMember as an owner" do
    @task.valid?
    @task.owner.should eql nil
    team_member = FactoryGirl.create(:team_member)
    @task.owner = team_member
    @task.owner.should eql team_member
  end

  subject { @task }
  it { should respond_to(:description) }
  it { should respond_to(:story) }
  it { should respond_to(:status) }
  it { should respond_to(:owner) }
  it { should be_valid }
end
