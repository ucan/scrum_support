class TeamMember < ActiveRecord::Base
  attr_accessible :name, :email
  validates_presence_of :name, :email

  has_many :memberships, dependent: :destroy, uniq: true, inverse_of: :team_member
  has_many :projects, through: :memberships, uniq: true
  has_many :tasks, inverse_of: :owner, foreign_key: :owner_id
  
  def as_json(options = {})
    json = super(only: [:id, :name, :email])
    json['task'] = get_task_for_project(options[:project_id]) 
    json
  end

  def get_task_for_project(project_id) 
  	tasks.detect { |t| t.story.project.id == project_id }
  end

end
