require 'spec_helper'

describe ExternalTaskLink do
  before(:each) do
    @external_task_link = FactoryGirl.create(:external_task_link)
  end

  it "should not be valid without a linked_id" do
    @external_task_link.linked_id = nil
    @external_task_link.should have(1).error_on(:linked_id)
    @external_task_link.should_not be_valid
  end

  it "should not be valid without a task" do
    @external_task_link.task = nil
    @external_task_link.should have(1).error_on(:task)
    @external_task_link.should_not be_valid
  end

  it "should not be valid without an external_story_link" do
    @external_task_link.external_story_link = nil
    @external_task_link.should have(1).error_on(:external_story_link)
    @external_task_link.should_not be_valid
  end

  it "should delete its task when it is deleted" do
    task = @external_task_link.task
    task.should_not eql nil
    lambda { task.reload }.should_not raise_error
    @external_task_link.destroy
    lambda { task.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should have a unique {task, linked_id} pair" do
    task = @external_task_link.task
    linked_id = @external_task_link.linked_id
    etl2 = FactoryGirl.build(:external_task_link, task: task, linked_id: linked_id)
    lambda { etl2.save! }.should raise_error(ActiveRecord::RecordNotUnique)
  end

  subject { @external_task_link }
  it { should respond_to(:linked_id) }
  it { should respond_to(:external_story_link) }
  it { should respond_to(:task) }
  it { should be_valid }
end
