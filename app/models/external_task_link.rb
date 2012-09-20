class ExternalTaskLink < ActiveRecord::Base
  attr_accessible :linked_id, :task, :external_story_link

  belongs_to :task
  belongs_to :external_story_link, inverse_of: :external_task_links

  validates_presence_of :linked_id, :external_story_link, :task

  before_destroy :destroy_task

  protected
  def destroy_task
    task.destroy
  end
end
