require 'spec_helper'
require 'story'
require 'project'
require 'task'

describe Story do

	before(:each) do
	    @story = FactoryGirl.create(:story)
	end
 
    it "should not be valid without a title" do
    	@story.title = nil
        @story.should have(1).error_on(:title)
    	@story.should_not be_valid 
    end

    it "should not be valid without a project" do
    	@story.project = nil
        @story.should have(1).error_on(:project)
    	@story.should_not be_valid 
    end

    it "should have tasks" do
        @story.tasks.length.should eql 0
        @story.save()
        @task = FactoryGirl.create(:task)
        #@task.save()
        # TODO Fix - this line shouldn't be needed.
        @story.tasks << @task
        @story.tasks.length.should eql 1
        @story.tasks[0].story.should eql @story
    end

    subject { @story }
    it { should respond_to(:title) }
    it { should respond_to(:project) }
    it { should be_valid }
end
