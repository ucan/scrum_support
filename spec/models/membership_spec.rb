require 'spec_helper'
require 'membership'

describe Membership do
  before(:each) do
    @team_member = FactoryGirl.create(:team_member)
    @project = FactoryGirl.create(:project)
  end

  it "should not be valid without a team_member" do
    membership = Membership.new(project: @project)
    membership.should have(1).error_on(:team_member)
    membership.should_not be_valid
  end

  it "should not be valid without a project" do
    membership = Membership.new(team_member: @team_member)
    membership.should have(1).error_on(:project)
    membership.should_not be_valid
  end

  it "should have an id when valid and saved" do
    membership = Membership.new(project: @project, team_member: @team_member)
    membership.should be_valid
    membership.save
    membership.id.nil?.should == false
  end

  it "should not allow more than membership relationship between one team_member and one project" do
    membership1 = Membership.new(team_member: @team_member, project: @project)
    membership1.save!
    membership2 = Membership.new(team_member: @team_member, project: @project)
    @team_member.should be_valid
    @project.should be_valid
    membership2.should_not be_valid
    lambda { membership2.save! }.should raise_error(ActiveRecord::RecordInvalid)
  end

  subject { membership = Membership.new(project: @project, team_member: @team_member) }
  it { should respond_to(:project) }
  it { should respond_to(:team_member) }
  it { should be_valid }
end
