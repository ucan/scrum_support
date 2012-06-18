require 'spec_helper'
require "person"

describe Person do
	before(:each) do
		@person = Person.new
	    @person.firstName = "Dave"
	    @person.lastName = "White"
	    @person.email = "White"
	    @person.userName = "dkw38"
	end

	it "should be valid" do
	    @person.should be_valid
	end

	it "should have a first name" do
		@person.firstName = ""
   		@person.should have(1).error_on(:firstName)
	 	@person.should_not be_valid
	end

	it "should have a last name" do
	    @person.lastName = ""
   		@person.should have(1).error_on(:lastName)
	 	@person.should_not be_valid
	end

	it "should have a user name" do
	 	@person.userName = ""
   		@person.should have(1).error_on(:userName)
	 	@person.should_not be_valid
	end

	it "should have an email" do
	 	@person.email = ""
   		@person.should have(1).error_on(:email)
	 	@person.should_not be_valid
	end

	subject { @person }
    it { should respond_to(:firstName) }
    it { should respond_to(:lastName) }
    it { should respond_to(:userName) }
    it { should respond_to(:email) }
    it { should be_valid }
end
