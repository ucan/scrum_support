class Membership < ActiveRecord::Base
  attr_accessible :person, :project

  belongs_to :person
  belongs_to :project

  validates_associated :project, :person
  validates_presence_of :project, :person

end
