class Iteration < ActiveRecord::Base
	
  # TODO add start_date, end_date - plus add to json

  attr_accessible :project

	belongs_to :project, inverse_of: :iterations
    has_many :stories, dependent: :destroy, uniq: true, inverse_of: :iteration

    validates_associated :project
    validates_presence_of :project

  def to_s
    "Iteration #{id} of #{project}"
  end

  def as_json(options = {})
    super(only: [:id])
  end

end