require 'spec_helper'

describe Project do

  before(:all) do
    @team_member = FactoryGirl.create(:team_member)
  end

  before(:each) do
    @project = FactoryGirl.create(:project)
  end

  it "should not be valid without a title" do
    @project.title = nil
    @project.should have(1).error_on(:title)
    @project.should_not be_valid
  end

  it "should be able to add 1 or more iterations" do
    @project.iterations.should be_empty
    it1 = FactoryGirl.create(:iteration)
    @project.iterations << it1
    @project.iterations.should =~ [it1]
    it2 = FactoryGirl.create(:iteration)
    @project.iterations << it2
    @project.iterations.should =~ [it1, it2]
  end

  it "should not be able to add a duplicate iteration" do
    it1 = FactoryGirl.create(:iteration)
    @project.iterations << it1 << it1
    @project.iterations.length.should == 1
    @project.iterations.should eql [it1]
  end

  it "should be able to remove 1 iteration" do
    it1 = FactoryGirl.create(:iteration)
    it2 = FactoryGirl.create(:iteration)
    @project.iterations << it1 << it2
    @project.iterations.delete(it2)
    @project.iterations.should_not include(it2)
    @project.iterations.should eql [it1]
  end

  it "should create a new membership when a new team_member is added to a project" do
    @project.team_members.should_not include(@team_member)
    @project.team_members = [@team_member]
    @project.team_members.should include(@team_member)
    @project.save()
    @project.memberships.length.should == 1
    @project.memberships.first.team_member.should eql @team_member
    @project.memberships.first.project.should eql @project
  end

  it "should throw a RecordInvalid error if a duplicate team_member is added to a project" do
    @project.team_members.should_not include(@team_member)
    @project.team_members = [@team_member]
    @project.save
    lambda { @project.team_members << @team_member }.should raise_error(ActiveRecord::RecordInvalid)
  end

  subject { @project }
  it { should respond_to(:title) }
  it { should respond_to(:iterations) }
  it { should respond_to(:memberships) }
  it { should respond_to(:team_members) }
  it { should respond_to(:current_iteration_id) }
  it { should respond_to(:backlog) }
  it { should respond_to(:current_iteration) }
  it { should be_valid }
end
