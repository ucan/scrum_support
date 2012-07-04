class Membership < ActiveRecord::Base
  attr_accessible :team_member, :project

  belongs_to :team_member, :inverse_of => :memberships
  belongs_to :project, :inverse_of => :memberships

  validates_associated :project, :team_member
  validates_presence_of :project, :team_member
  validates_uniqueness_of :project_id, :scope => :team_member_id, :allow_nil => true #:if => :others_valid

end
