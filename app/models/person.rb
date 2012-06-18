class Person < ActiveRecord::Base
  attr_accessible :email, :firstName, :lastName, :username
end
