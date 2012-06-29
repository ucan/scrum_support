class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation, :auth_token

  has_many :accounts, :dependent => :destroy, :uniq => true, :inverse_of => :user

  before_save :ensure_auth_token

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email


  def as_json(options = {})
    super(:only => [:email, :auth_token])
  end

  def ensure_auth_token
    if !self.auth_token
      #self.auth_token = Digest::SHA1.hexdigest(rand(Rails.application.config.RAND_SEED).to_s)
      self.auth_token = SecureRandom.hex(16)
    end
  end
end