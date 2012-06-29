class TaskMapping < ActiveRecord::Base
  attr_accessible :linked_id, :story_mapping, :task

  #belongs_to :account, :inverse_of => :task_mappings
  belongs_to :task
  belongs_to :story_mapping, inverse_of: :task_mappings

  validates_presence_of :linked_id, :story_mapping, :task

  before_destroy :destroy_task

  protected
  def destroy_task  	
  	task.destroy
  end
end
