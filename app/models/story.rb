class Story < ActiveRecord::Base
  attr_accessible :title, :project

  belongs_to :project, inverse_of: :stories
  has_many :tasks, uniq: true, dependent: :destroy, inverse_of: :story

  validates_presence_of :title
  validates_associated :project
  validates_presence_of :project

  def to_s
    @title
  end

  def as_json(options = {})
    super(only: [:id, :title])
  end
end
