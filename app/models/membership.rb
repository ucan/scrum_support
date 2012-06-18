class Membership < ActiveRecord::Base
  attr_accessible :person, :project

  belongs_to :person
  belongs_to :project
  #has_many :behaviours

  validates_associated :project, :person
  validates_presence_of :project, :person

  def initialize(attributes = {})
	  	super
	    @person = attributes[:person]
	    @project = attributes[:project]
	end
end
