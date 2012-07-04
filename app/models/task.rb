class Task < ActiveRecord::Base
  attr_accessible :description, :story, :status
  belongs_to :story

  belongs_to :owner, class_name: TeamMember 
  validates_inclusion_of :status, :in => %w(not_started started blocked done)

  validates_presence_of :description, :story, :status

  def completed?
    self.status == :done.to_s
  end

  def started?
    self.status == :started.to_s
  end

  def blocked?
    self.status == :blocked.to_s
  end

  def not_started?
    self.status == :not_started.to_s
  end

  def complete
    self.status = :done.to_s
  end

  def start
    self.status = :started.to_s
  end

  def block
    self.status = :blocked.to_s
  end

  def as_json(options = {})
    super(:only => [:id, :description, :status])
  end

  before_validation :init
  def init
    self.status ||= :not_started.to_s
  end


end
