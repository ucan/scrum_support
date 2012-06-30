class ExternalProjectLink < ActiveRecord::Base
  attr_accessible :linked_id, :account, :project

  belongs_to :account, :inverse_of => :external_project_links
  belongs_to :project

  has_many :external_story_links, :dependent => :destroy, :uniq => true, :validate => true, :inverse_of => :external_project_link

  validates_presence_of :linked_id, :account, :project

  before_destroy :destroy_project

  protected
  def destroy_project
  	project.destroy
  end
end
