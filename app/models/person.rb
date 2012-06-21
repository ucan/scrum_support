class Person < ActiveRecord::Base
    attr_accessible :firstName, :lastName, :userName, :email
    validates_presence_of :firstName, :lastName, :userName, :email

	has_many :memberships, :uniq => true, :inverse_of => :person
	has_many :projects, :through => :memberships, :uniq => true
end
