class ApiKey < ActiveRecord::Base
  attr_accessible :auth_token

  belongs_to :user

  before_create :generate_auth_token

  def as_json(options = {})
    super(only: [:auth_token])
  end

  private
  def generate_auth_token
    begin
      self.auth_token = SecureRandom.hex(16)
    end while self.class.exists?(auth_token: auth_token)
  end
end
