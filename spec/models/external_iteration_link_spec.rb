require 'spec_helper'

describe ExternalIterationLink do
  before(:each) do
    @external_iteration_link = FactoryGirl.create(:external_iteration_link)
  end

  it "should not be valid without a linked_id" do
    @external_iteration_link.linked_id = nil
    @external_iteration_link.should have(1).error_on(:linked_id)
    @external_iteration_link.should_not be_valid
  end

  it "should not be valid without an iteration" do
    @external_iteration_link.iteration = nil
    @external_iteration_link.should have(1).error_on(:iteration)
    @external_iteration_link.should_not be_valid
  end

  it "should not be valid without an external_project_link" do
    @external_iteration_link.external_project_link = nil
    @external_iteration_link.should have(1).error_on(:external_project_link)
    @external_iteration_link.should_not be_valid
  end

  it "should trigger deletion of its iteration when it is deleted" do
    iteration = @external_iteration_link.iteration
    iteration.should_not eql nil
    lambda { iteration.reload }.should_not raise_error
    @external_iteration_link.destroy
    lambda { iteration.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should trigger deletion of its external_story_links when it is deleted" do
  	esl1 = FactoryGirl.create(:external_story_link)
  	esl2 = FactoryGirl.create(:external_story_link)
  	@external_iteration_link.external_story_links << esl1 << esl2
    @external_iteration_link.external_story_links.count.should eql 2
    lambda { esl1.reload }.should_not raise_error
    lambda { esl2.reload }.should_not raise_error
    @external_iteration_link.destroy
    lambda { esl1.reload }.should raise_error(ActiveRecord::RecordNotFound)
    lambda { esl2.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end

  it "should have a unique {iteration, linked_id} pair" do
    iteration = @external_iteration_link.iteration
    linked_id = @external_iteration_link.linked_id
    eil2 = FactoryGirl.build(:external_iteration_link, iteration: iteration, linked_id: linked_id)
    lambda { eil2.save! }.should raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should not allow duplicate external_story_links to be added" do
  	esl = FactoryGirl.create(:external_story_link)
  	@external_iteration_link.external_story_links << esl << esl
  	@external_iteration_link.external_story_links.count.should eql 1
  	@external_iteration_link.external_story_links.should eql [esl]
  end

  subject { @external_iteration_link }
  it { should respond_to(:linked_id) }
  it { should respond_to(:external_project_link) }
  it { should respond_to(:iteration) }
  it { should be_valid }
end
