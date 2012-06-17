class Story < ActiveRecord::Base
  attr_accessible :title, :project

  belongs_to :project

  validates_presence_of :title
  validates_associated :project
  validates_presence_of :project

  def initialize(attributes = {})
  	super
  	@title = attributes[:title]
  	@project = attributes[:project]
  end

  def to_s
  	@title
  end

end
