class Project < ActiveRecord::Base
  attr_accessible :title

  has_many :stories

  validates_presence_of :title

  def initialize(attributes = {})
  	super
    @title = attributes[:title]
  end

  def to_s
  	@title
  end

end
