require 'spec_helper'
require 'story'
require 'project'

describe Task do	

	before(:each) do
	    @project = FactoryGirl.create(:project)         
        @story = FactoryGirl.create(:story, project: @project)
	    @task1 = FactoryGirl.build(:task, story: @story)
	end

    it "should not be valid without a description" do
    	@task1.description = nil
        @task1.should have(1).error_on(:description)
    	@task1.should_not be_valid
    end

    it "should not be valid without a story" do
    	@task1.story = nil
        @task1.should have(1).error_on(:story)
    	@task1.should_not be_valid
    end

    it "should have a valid default status" do
        @task1.status.should eql nil
        @task1.valid?
        @task1.should be_valid
    	@task1.not_started?.should eql true
    end

    it "should be able to change its status" do
        @task1.valid?
    	@task1.not_started?.should eql true
    	@task1.start
    	@task1.started?.should eql true
    	@task1.block
    	@task1.blocked?.should eql true
    	@task1.completed?.should eql false
    	@task1.complete
    	@task1.completed?.should eql true
    end
end
