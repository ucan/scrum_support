class Person < ActiveRecord::Base
	attr_accessible :firstName, :lastName, :userName, :email
	validates_presence_of :firstName, :lastName, :userName, :email
  
	def initialize(attributes = {})
	  	super
	    @firstName = attributes[:firstName]
	    @lastName = attributes[:lastName]
	    @userName = attributes[:userName]
	    @email = attributes[:email]
	end
end
