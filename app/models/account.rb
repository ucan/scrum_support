class Account < ActiveRecord::Base
  attr_accessible :email

  belongs_to :user, inverse_of: :accounts
  has_and_belongs_to_many :external_project_links, validate: true, uniq: true#, dependent: :destroy, uniq: true, validate: true#, inverse_of: :account
  has_many :projects, uniq: true, through: :external_project_links
  belongs_to :team_member, class_name: TeamMember
  
  validates_associated :user
  validates_presence_of :user
  validates_presence_of :email
  validates_uniqueness_of :email

  def fetch_projects
    raise NotImplementedError.new
  end

  def fetch_iterations(options = {})
    raise NotImplementedError.new
  end

  def fetch_members(project)
    raise NotImplementedError.new
  end

  def fetch_stories(iteration)
    raise NotImplementedError.new
  end

  def fetch_tasks(story)
    raise NotImplementedError.new
  end

  def as_json(options = {})
    json = super(only: [:id, :type, :email])
    json["team_member"] = self.team_member # Not sure why this can't be included in the only: block
    json
  end
end
