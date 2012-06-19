require 'spec_helper'
require 'membership'

describe Membership do
    before(:each) do
  		@person = Person.new(firstName: "Dave", lastName: "White", email: "dkw38@uclive.ac.nz", userName: "dkw38")
  		@person.save 
  		@project = Project.new(title: "Test Project")
  		@project.save
	end

	it "should not be valid without a person" do  
		membership = Membership.new(project: @project) 
		membership.should have(1).error_on(:person)
		membership.should_not be_valid 
	end

	it "should not be valid without a project" do 
		membership = Membership.new(person: @person) 
		membership.should have(1).error_on(:project)
		membership.should_not be_valid
	end
	
	it "should have an id when valid and saved" do
		membership = Membership.new(project: @project, person: @person)
		membership.should be_valid
		membership.save
		membership.id.nil?.should == false
	end

	it "should not allow more than membership relationship between one person and one project" do
		membership1 = Membership.new(person: @person, project: @project)
		membership1.save
		membership2 = Membership.new(person: @person, project: @project)
		@person.should be_valid
		@project.should be_valid
		membership2.should_not be_valid
	end

	subject { membership = Membership.new(project: @project, person: @person) } 
	it { should respond_to(:project) } 
    it { should respond_to(:person) } 
    it { should be_valid }
end
