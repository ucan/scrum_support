require 'spec_helper'

describe ExternalStoryLink do
  before(:each) do
    @storyMapping = FactoryGirl.create(:external_story_link)
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
    @storyMapping.external_project_link = nil
    @storyMapping.should have(1).error_on(:external_project_link)
    @storyMapping.should_not be_valid
  end

  subject { @storyMapping }
  it { should respond_to(:linked_id) }
  it { should respond_to(:external_project_link) }
  it { should respond_to(:story) }
  it { should be_valid }
end
