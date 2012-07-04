require 'spec_helper'
require 'team_member'
require 'project'
require 'membership'

describe TeamMember do
	before(:each) do
		@team_member = FactoryGirl.create(:team_member)

 		@project1 = FactoryGirl.create(:project)
	    @project2 = FactoryGirl.create(:project)
		@membership1 = Membership.new(team_member: @team_member, project: @project1)  
	    @membership2 = Membership.new(team_member: @team_member, project: @project2) 
	end

	it "should be valid" do
	    @team_member.should be_valid
	end

	it "should have a name" do
		@team_member.name = ""
   		@team_member.should have(1).error_on(:name)
	 	@team_member.should_not be_valid
	end	

	it "should have an email" do
	 	@team_member.email = ""
   		@team_member.should have(1).error_on(:email)
	 	@team_member.should_not be_valid
	end
 
	it "should be able to add 1 or more projects" do
		@team_member.projects.should be_empty
		@team_member.projects << @project1
		@team_member.projects.should =~ [@project1]
		@team_member.projects << @project2
		@team_member.projects.should =~ [@project1, @project2]
	end

	it "should not be able to add a duplicate project" do
		@team_member.projects << @project1
		lambda { @team_member.projects << @project1 }.should raise_error(ActiveRecord::RecordInvalid)
		@team_member.projects.length.should == 1
		@team_member.projects.should == [@project1]
	end

	it "should be able to remove 1 project" do
		@team_member.projects << @project1 << @project2
		@team_member.projects.delete(@project1)
		@team_member.projects.should_not include(@project1)
		@team_member.projects.should == [@project2]
	end

	it "should be able to add 1 or more memberships" do
		@team_member.memberships << @membership1
		@team_member.memberships.should == [@membership1]
		@team_member.memberships << @membership2
		@team_member.memberships.should =~ [@membership1, @membership2]
	end

	it "should not be able to add a duplicate membership" do
		@team_member.memberships << @membership1 << @membership1
		@team_member.memberships.length.should == 1
		@team_member.memberships.should == [@membership1]
	end

	subject { @team_member }    
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:projects) }
    it { should respond_to(:memberships) }
    it { should be_valid }
end
