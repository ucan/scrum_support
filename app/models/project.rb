class Project < ActiveRecord::Base
  attr_accessible :title

  has_one :project_mapping, :inverse_of => :project
  has_one :account, :through => :project_mapping, :inverse_of => :projects

  has_many :stories, :uniq => true, :inverse_of => :project
  has_many :memberships, :uniq => true, :inverse_of => :project
  has_many :people, :through => :memberships, :uniq => true

  validates_presence_of :title

  def to_s
  	@title
  end

  def as_json(options = {})
    super(:only => [:id, :title])
  end

end
