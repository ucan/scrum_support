class ProjectMapping < ActiveRecord::Base

  attr_accessible :linked_id, :account, :project

  belongs_to :account, :inverse_of => :project_mappings
  belongs_to :project, :inverse_of => :project_mapping

  validates_presence_of :linked_id, :account, :project
end
