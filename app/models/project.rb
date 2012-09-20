class Project < ActiveRecord::Base
  attr_accessible :title

  has_many :stories, dependent: :destroy, uniq: true, inverse_of: :project
  has_many :memberships, dependent: :destroy, uniq: true, inverse_of: :project
  has_many :team_members, through: :memberships, uniq: true

  validates_presence_of :title

  def to_s
    @title
  end

  def as_json(options = {})
    super(only: [:id, :title])
  end
  

end
