class Story < ActiveRecord::Base
  attr_accessible :title, :project

  belongs_to :project

  validates_presence_of :title
  validates_associated :project
  validates_presence_of :project

  def to_s
  	@title
  end

end
