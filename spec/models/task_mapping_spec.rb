require 'spec_helper'

describe TaskMapping do
  before(:each) do
    @taskMapping = FactoryGirl.create(:task_mapping)
  end

  it "should not be valid without a linked_id" do
    @taskMapping.linked_id = nil
    @taskMapping.should have(1).error_on(:linked_id)
    @taskMapping.should_not be_valid
  end

  it "should not be valid without a task" do
    @taskMapping.task = nil
    @taskMapping.should have(1).error_on(:task)
    @taskMapping.should_not be_valid
  end

  it "should not be valid without a story_mapping" do
    @taskMapping.story_mapping = nil
    @taskMapping.should have(1).error_on(:story_mapping)
    @taskMapping.should_not be_valid
  end

  subject { @taskMapping }
  it { should respond_to(:linked_id) }
  it { should respond_to(:story_mapping) }
  it { should respond_to(:task) }
  it { should be_valid }
end
