require 'spec_helper'
require 'story'
require 'project'

describe Story do

	before(:each) do
	    @story = Story.new(title: "Test Story", project_id: Project.new(title: "Test Project").id)
	end
 
    it "should not be valid without a title" do
    	@story.title = nil
    	@story.should_not be_valid 
    end

    it "should not be valid without a project" do
    	@story.project = nil
    	@story.should_not be_valid 
    end

    subject { @story }
    it { should respond_to(:title) }
    it { should respond_to(:project) }
    it { should be_valid }
end
