require 'spec_helper'

describe Story do

  before(:each) do
    @story = FactoryGirl.create(:story)
  end

  it "should not be valid without a title" do
    @story.title = nil
    @story.should have(1).error_on(:title)
    @story.should_not be_valid
  end

  it "should not be valid without an iteration" do
    @story.iteration = nil
    @story.should have(1).error_on(:iteration)
    @story.should_not be_valid
  end

  it "should be able to add 1 or more tasks" do
    @story.tasks.length.should eql 0
    task1 = FactoryGirl.create(:task)
    @story.tasks << task1
    @story.tasks.length.should eql 1
    task1.story.should eql @story
    task2 = FactoryGirl.create(:task)
    @story.tasks << task2
    @story.tasks.length.should eql 2
  end

  it "should not be able to add duplicate tasks" do
    @story.tasks.length.should eql 0
    task = FactoryGirl.create(:task)
    @story.tasks << task << task
    @story.tasks.length.should eql 1
  end

  subject { @story }
  it { should respond_to(:title) }
  it { should respond_to(:iteration) }
  it { should respond_to(:tasks) }
  it { should be_valid }
end
