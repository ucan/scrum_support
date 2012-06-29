require 'spec_helper'

describe StoryMapping do
  before(:each) do
    @storyMapping = FactoryGirl.create(:story_mapping)
  end

  it "should not be valid without a linked_id" do
    @storyMapping.linked_id = nil
    @storyMapping.should have(1).error_on(:linked_id)
    @storyMapping.should_not be_valid
  end

  it "should not be valid without a story" do
    @storyMapping.story = nil
    @storyMapping.should have(1).error_on(:story)
    @storyMapping.should_not be_valid
  end

  it "should not be valid without a project_mapping" do
    @storyMapping.project_mapping = nil
    @storyMapping.should have(1).error_on(:project_mapping)
    @storyMapping.should_not be_valid
  end

  subject { @storyMapping }
  it { should respond_to(:linked_id) }
  it { should respond_to(:project_mapping) }
  it { should respond_to(:story) }
  it { should be_valid }
end

