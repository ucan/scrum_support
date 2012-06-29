class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :password_confirmation, :api_key

  has_one :api_key
  has_many :accounts, :dependent => :destroy, :uniq => true, :inverse_of => :user

  before_save :ensure_api_key

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email


  def as_json(options = {})
    super(:only => [:email])
  end

  def ensure_api_key
    self.api_key = ApiKey.new if self.api_key.nil?
  end

  def auth_token
    self.api_key.auth_token
  end
end