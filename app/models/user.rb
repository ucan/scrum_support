class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation, :authentication_token

  has_many :accounts, :uniq => true, :inverse_of => :user

  before_save :ensure_authentication_token

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email


  def as_json(options = {})
    super(:only => [:email, :authentication_token])
  end

  def ensure_authentication_token
    if !self.authentication_token
      self.authentication_token = Digest::SHA1.hexdigest(rand(Rails.application.config.RAND_SEED).to_s)
    end
  end
end