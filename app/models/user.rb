class User < ActiveRecord::Base
  has_secure_password
  devise :token_authenticatable

  attr_accessible :email, :password, :authentication_token

  has_many :accounts, :uniq => true, :inverse_of => :user

  before_save :ensure_authentication_token

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email


  def as_json(options = {})
    super(:only => [:email, :authentication_token])
  end
end