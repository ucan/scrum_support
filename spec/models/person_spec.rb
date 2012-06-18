require 'spec_helper'

describe "Person" do
	before(:each) do
	   @person = Person.new
	   @person.firstName = "Dave"
	   @person.lastName = "White"
	   @person.email = "White"
	   @person.username = "dkw38"
	 end

	 it "should be valid" do
	   @person.should be_valid
	 end

	 it "should have a first name" do
	 	@person.firstName = ""
   		@person.should have(1).error_on(:firstName)
	 	@person.should_not be_valid
	 end

	 it "should have an email" do
	 	@person.email = ""
   		@person.should have(1).error_on(:email)
	 	@person.should_not be_valid
	 end
end
