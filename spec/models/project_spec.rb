require 'spec_helper'
require 'project'
require 'story'

describe Project do

	before(:each) do
	    @project = Project.new(title: "Test Project") 
        
        @story1 = Story.new(title: "Test story 1", project: @project)
        @story2 = Story.new(title: "Test story 2", project: @project)
	end

    it "should not be valid without a title" do
    	@project.title = nil
        @project.should have(1).error_on(:title)
    	@project.should_not be_valid
    end

    it "should be able to add 1 or more storys" do
        @project.storys.should be_empty
        @project.storys << @story1
        @project.storys.should =~ [@story1]
        @project.storys << @story2
        @project.storys.should =~ [@story1, @story2]
    end

    it "should not be able to add a duplicate story" do
        @project.storys << @story1 << @story1
        @project.storys.length.should == 1
        @project.storys.should == [@story1]
    end

    it "should be able to remove 1 story" do
        @project.storys << @story1 << @story2
        @project.storys.delete(@story1)
        @project.storys.should_not include(@story1)
        @project.storys.should == [@story2]
    end

    subject { @project } 
    it { should respond_to(:title) } 
    it { should respond_to(:storys) } 
    it { should respond_to(:memberships) } 
    it { should be_valid }
end

