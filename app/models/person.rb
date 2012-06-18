class Person < ActiveRecord::Base
  attr_accessible :email, :firstName, :lastName, :username
	validates_presence_of :email, :firstName, :lastName, :username

end
