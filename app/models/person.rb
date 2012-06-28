class Person < ActiveRecord::Base
    attr_accessible :name, :email
    validates_presence_of :name, :email

	has_many :memberships, :uniq => true, :inverse_of => :person
	has_many :projects, :through => :memberships, :uniq => true

	def as_json(options = {})
    	super(:only => [:id, :name, :email])
  	end
end
