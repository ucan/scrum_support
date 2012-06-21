class Project < ActiveRecord::Base
  attr_accessible :title

  has_one :project_mapping, :inverse_of => :project

  has_many :storys, :uniq => true, :inverse_of => :project
  has_many :memberships, :uniq => true, :inverse_of => :project
  has_many :people, :through => :memberships, :uniq => true

  validates_presence_of :title

  def to_s
  	@title
  end

end
