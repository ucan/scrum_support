class ExternalIterationLink < ActiveRecord::Base
  attr_accessible :linked_id, :iteration, :external_project_link

  belongs_to :iteration
  belongs_to :external_project_link, inverse_of: :external_iteration_links
  has_many :external_story_links, dependent: :destroy, uniq: true, validate: true, inverse_of: :external_iteration_link

  validates_presence_of :linked_id, :external_project_link, :iteration

  before_destroy :destroy_iteration

  protected
  def destroy_iteration
    iteration.destroy
  end
end
