class Account < ActiveRecord::Base

  belongs_to :user, :inverse_of => :accounts
  has_and_belongs_to_many :external_project_links, :validate => true, :uniq => true#, :dependent => :destroy, :uniq => true, :validate => true#, :inverse_of => :account
  has_many :projects, :uniq => true, :through => :external_project_links
 
  validates_associated :user
  validates_presence_of :user
 
  def fetch_projects
    raise NotImplementedError.new
  end

  def fetch_members(project)
    raise NotImplementedError.new
  end

  def fetch_stories(project)
    raise NotImplementedError.new
  end

  def fetch_tasks(story)
    raise NotImplementedError.new
  end

  def sync
    raise NotImplementedError.new
  end

  def as_json(options = {})
    super(:only => [:id, :type])
  end

end
