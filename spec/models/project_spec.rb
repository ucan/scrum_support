require 'spec_helper'
require 'project'
require 'story'
require 'membership'

describe Project do

    before(:all) do
        @person = FactoryGirl.create(:person)
    end

	before(:each) do
	    @project = FactoryGirl.create(:project)
        @story1 = Story.new(title: "Test story 1", project: @project)
        @story2 = Story.new(title: "Test story 2", project: @project)
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

    it "should create a new membership when a new person is added to a project" do
        @project.people.should_not include(@person)
        @project.people = [@person]
        @project.people.should include(@person)
        @project.save()
        @project.memberships.length.should == 1
        @project.memberships.first.person.should eql @person
        @project.memberships.first.project.should eql @project 
    end

    it "should throw a RecordInvalid error if a duplicate person is added to a project" do
        @project.people.should_not include(@person)
        @project.people = [@person]        
        @project.save
        lambda { @project.people << @person }.should raise_error(ActiveRecord::RecordInvalid)
    end

    subject { @project } 
    it { should respond_to(:title) }  
    it { should respond_to(:stories) } 
    it { should respond_to(:memberships) }
    it { should respond_to(:people) }
    it { should be_valid }
end

