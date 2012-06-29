class ProjectMapping < ActiveRecord::Base
  attr_accessible :linked_id, :account, :project

  belongs_to :account, :inverse_of => :project_mappings
  belongs_to :project

  has_many :story_mappings, :dependent => :destroy, :uniq => true, :validate => true, :inverse_of => :project_mapping

  validates_presence_of :linked_id, :account, :project

  before_destroy :destroy_project

  protected
  def destroy_project
  	puts "destrpy project"
  	project.destroy
  end
end
