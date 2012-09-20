class Project < ActiveRecord::Base
  attr_accessible :title, :current_iteration_id
  
  has_many :iterations, dependent: :destroy, uniq: true, inverse_of: :project
  has_many :memberships, dependent: :destroy, uniq: true, inverse_of: :project
  has_many :team_members, through: :memberships, uniq: true

  validates_presence_of :title

  # before_create :init
  # def init
  #   self.current_iteration_id ||= -1
  # end

  def to_s
    @title
  end

  def as_json(options = {})
    super(only: [:id, :title, :current_iteration_id])
  end

  def current_iteration
    iterations.where(id: :current_iteration_id).first
  end

  def backlog
    iterations.where("id > ?", self.current_iteration_id)
  end

  def done_iterations
    iterations.where("id < ?", self.current_iteration_id)
  end
end
