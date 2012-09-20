require 'spec_helper'

describe Iteration do
  before(:each) do
    @iteration = FactoryGirl.create(:iteration)
  end

  it "should not be valid without a project" do
    @iteration.project = nil
    @iteration.should have(1).error_on(:project)
    @iteration.should_not be_valid
  end

  it "should be able to add 1 or more stories" do
    @iteration.stories.length.should eql 0
    story1 = FactoryGirl.create(:story)
    @iteration.stories << story1
    @iteration.stories.length.should eql 1
    story1.iteration.should eql @iteration
    story2 = FactoryGirl.create(:story)
    @iteration.stories << story2
    @iteration.stories.length.should eql 2
  end

  it "should not be able to add duplicate stories" do
    @iteration.stories.length.should eql 0
    story = FactoryGirl.create(:story)
    @iteration.stories << story << story
    @iteration.stories.length.should eql 1
  end

  subject { @iteration }
  it { should respond_to(:project) }
  it { should respond_to(:stories) }
  it { should be_valid }
end
