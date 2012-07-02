class ExternalStoryLink < ActiveRecord::Base
  attr_accessible :linked_id, :project_link, :story

  belongs_to :story
  belongs_to :external_project_link, inverse_of: :external_story_links

  has_many :external_task_links, :dependent => :destroy, :uniq => true, :validate => true, :inverse_of => :external_story_links

  validates_presence_of :linked_id, :external_project_link, :story

  before_destroy :destroy_story

  protected
  def destroy_story
  	story.destroy
  end
end
