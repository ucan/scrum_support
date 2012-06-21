class Membership < ActiveRecord::Base
  attr_accessible :person, :project

  belongs_to :person, :inverse_of => :memberships
  belongs_to :project, :inverse_of => :memberships

  validates_associated :project, :person
  validates_presence_of :project, :person
  validates_uniqueness_of :project_id, :scope => :person_id, :allow_nil => true #:if => :others_valid

  # def others_valid?()
  #   !@project.nil? && !@person.nil? && !@project.changed? && !@person.changed?
  # end
end
