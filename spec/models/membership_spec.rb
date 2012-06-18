require 'spec_helper'
require 'membership'

describe Membership do
    before(:each) do
  		@person = Person.new(firstName: "Dave", lastName: "White", email: "dkw38@uclive.ac.nz", userName: "dkw38")
  		@project = Project.new(title: "Test Project")
	    @membership = Membership.new(person: @person, project: @project) 
	end

	it "should not be valid without a person" do
		@membership.person = nil
		@membership.should have(1).error_on(:person)
		@membership.should_not be_valid
	end

	it "should not be valid without a project" do
		@membership.project = nil
		@membership.should have(1).error_on(:project)
		@membership.should_not be_valid
	end
	
	#Test that there cannot be two membership relationships between one person and one project
	# it "should not allow more than" do
	# 	@membership.save
	# 	membership2 = Membership.new(person: @person, project: @project)
	# 	membership2.save
	# 	@membership.id.should == membership2.id
	# end

	subject { @membership } 
	it { should respond_to(:project) } 
    it { should respond_to(:person) } 
    it { should be_valid }
end
