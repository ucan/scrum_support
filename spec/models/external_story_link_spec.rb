require 'spec_helper'

describe ExternalStoryLink do
  before(:each) do
    @external_story_link = FactoryGirl.create(:external_story_link)
  end

  it "should not be valid without a linked_id" do
    @external_story_link.linked_id = nil
    @external_story_link.should have(1).error_on(:linked_id)
    @external_story_link.should_not be_valid
  end

  it "should not be valid without a story" do
    @external_story_link.story = nil
    @external_story_link.should have(1).error_on(:story)
    @external_story_link.should_not be_valid
  end

  it "should not be valid without an external_iteration_link" do
    @external_story_link.external_iteration_link = nil
    @external_story_link.should have(1).error_on(:external_iteration_link)
    @external_story_link.should_not be_valid
  end

  it "should trigger deletion of its story when it is deleted" do
    story = @external_story_link.story
    story.should_not eql nil
    lambda { story.reload }.should_not raise_error
    @external_story_link.destroy
    lambda { story.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should trigger deletion of its external_task_links when it is deleted" do
    etl1 = FactoryGirl.create(:external_task_link)
    etl2 = FactoryGirl.create(:external_task_link)
    @external_story_link.external_task_links << etl1 << etl2
    @external_story_link.external_task_links.count.should eql 2

    lambda { etl1.reload }.should_not raise_error
    lambda { etl2.reload }.should_not raise_error
    @external_story_link.destroy
    lambda { etl1.reload }.should raise_error(ActiveRecord::RecordNotFound)
    lambda { etl2.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should not allow duplicate external_tasks_links to be added" do
    etl = FactoryGirl.create(:external_task_link)
    @external_story_link.external_task_links << etl << etl
    @external_story_link.external_task_links.count.should eql 1
    @external_story_link.external_task_links.should eql [etl]
  end

  it "should have a unique {story, linked_id} pair" do
    story = @external_story_link.story
    linked_id = @external_story_link.linked_id
    duplicate = FactoryGirl.build(:external_story_link, story: story, linked_id: linked_id)
    lambda { duplicate.save! }.should raise_error(ActiveRecord::RecordNotUnique)
  end

  subject { @external_story_link }
  it { should respond_to(:linked_id) }
  it { should respond_to(:external_iteration_link) }
  it { should respond_to(:story) }
  it { should be_valid }
end
