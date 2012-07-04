require 'spec_helper'

describe Project do

    before(:all) do
        @team_member = FactoryGirl.create(:team_member)
    end

	before(:each) do
	    @project = FactoryGirl.create(:project)
        @story1 = FactoryGirl.build(:story, project: @project)
        @story2 = FactoryGirl.build(:story, project: @project)
	end

    it "should not be valid without a title" do
    	@project.title = nil
        @project.should have(1).error_on(:title)
    	@project.should_not be_valid
    end 

    it "should be able to add 1 or more storys" do
        @project.stories.should be_empty
        @project.stories << @story1
        @project.stories.should =~ [@story1]
        @project.stories << @story2
        @project.stories.should =~ [@story1, @story2]
    end
 
    it "should not be able to add a duplicate story" do
        @project.stories << @story1 << @story1
        @project.stories.length.should == 1 
        @project.stories.should == [@story1]   
    end
 
    it "should be able to remove 1 story" do
        @project.stories << @story1 << @story2
        @project.stories.delete(@story1)
        @project.stories.should_not include(@story1)
        @project.stories.should == [@story2]
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
    it { should respond_to(:stories) } 
    it { should respond_to(:memberships) }
    it { should respond_to(:team_members) }
    it { should be_valid }
end

