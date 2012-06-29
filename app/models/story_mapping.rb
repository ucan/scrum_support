class StoryMapping < ActiveRecord::Base
  attr_accessible :linked_id, :project_mapping, :story

  #belongs_to :account, inverse_of: :story_mappings
  belongs_to :story
  belongs_to :project_mapping, inverse_of: :story_mappings

  has_many :task_mappings, :dependent => :destroy, :uniq => true, :validate => true, :inverse_of => :story_mapping

  validates_presence_of :linked_id, :project_mapping, :story

  before_destroy :destroy_story

  protected
  def destroy_story
  	puts "destrpy story"
  	story.destroy
  end
end
