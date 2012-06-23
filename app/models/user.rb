class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :token_authenticatable

  # :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :authentication_token
  attr_accessible :name #Just added for testing purposes. Probably needs a token or something?
  has_many :accounts, :uniq => true, :inverse_of => :user

  before_save :ensure_authentication_token

  def as_json(options = {})
    super(:only => [:name, :authentication_token])
  end
end