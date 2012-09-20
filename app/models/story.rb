class Story < ActiveRecord::Base

  # TODO add status - plus add to json

  attr_accessible :title, :iteration

  belongs_to :iteration, inverse_of: :stories
  has_many :tasks, uniq: true, dependent: :destroy, inverse_of: :story

  validates_presence_of :title
  validates_associated :iteration
  validates_presence_of :iteration

  def to_s
    @title
  end

  def as_json(options = {})
    super(only: [:id, :title])
  end
end
