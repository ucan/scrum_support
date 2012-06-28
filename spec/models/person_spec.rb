require 'spec_helper'
require 'person'
require 'project'
require 'membership'

describe Person do
	before(:each) do
		@person = FactoryGirl.create(:person)

 		@project1 = FactoryGirl.create(:project)
	    @project2 = FactoryGirl.create(:project)
		@membership1 = Membership.new(person: @person, project: @project1)  
	    @membership2 = Membership.new(person: @person, project: @project2) 
	end

	it "should be valid" do
	    @person.should be_valid
	end

	it "should have a name" do
		@person.name = ""
   		@person.should have(1).error_on(:name)
	 	@person.should_not be_valid
	end	

	it "should have an email" do
	 	@person.email = ""
   		@person.should have(1).error_on(:email)
	 	@person.should_not be_valid
	end
 
	it "should be able to add 1 or more projects" do
		@person.projects.should be_empty
		@person.projects << @project1
		@person.projects.should =~ [@project1]
		@person.projects << @project2
		@person.projects.should =~ [@project1, @project2]
	end

	it "should not be able to add a duplicate project" do
		@person.projects << @project1
		lambda { @person.projects << @project1 }.should raise_error(ActiveRecord::RecordInvalid)
		@person.projects.length.should == 1
		@person.projects.should == [@project1]
	end

	it "should be able to remove 1 project" do
		@person.projects << @project1 << @project2
		@person.projects.delete(@project1)
		@person.projects.should_not include(@project1)
		@person.projects.should == [@project2]
	end

	it "should be able to add 1 or more memberships" do
		@person.memberships << @membership1
		@person.memberships.should == [@membership1]
		@person.memberships << @membership2
		@person.memberships.should =~ [@membership1, @membership2]
	end

	it "should not be able to add a duplicate membership" do
		@person.memberships << @membership1 << @membership1
		@person.memberships.length.should == 1
		@person.memberships.should == [@membership1]
	end

	subject { @person }    
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:projects) }
    it { should respond_to(:memberships) }
    it { should be_valid }
end
