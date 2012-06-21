class Story < ActiveRecord::Base
  attr_accessible :title, :project

  belongs_to :project, :inverse_of => :storys
  has_many :tasks, :uniq => true, :dependent => :destroy, :inverse_of => :story

  validates_presence_of :title
  validates_associated :project
  validates_presence_of :project

  def to_s
  	@title
  end

end
