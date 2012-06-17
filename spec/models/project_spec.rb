require 'spec_helper'
require 'project'
require 'story'

describe Project do

	before(:each) do
	    @project = Project.new(title: "Test Project") 
	end

    it "should not be valid without a title" do
    	@project.title = nil
    	@project.should_not be_valid
    end

    subject { @project } 
    it { should respond_to(:title) } 
    it { should be_valid }
end

