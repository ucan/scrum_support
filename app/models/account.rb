class Account < ActiveRecord::Base

  belongs_to :user, :inverse_of => :accounts
  has_many :project_mappings, :uniq => true, :validate => true, :inverse_of => :account
  has_many :projects, :uniq => true, :through => :project_mappings

  validates_associated :user
  validates_presence_of :user
 
  def fetch_projects
    raise NotImplementedError.new
  end

end