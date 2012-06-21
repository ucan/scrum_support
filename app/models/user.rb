class User < ActiveRecord::Base
  attr_accessible :name #Just added for testing purposes. Probably needs a token or something?
  has_many :accounts, :uniq => true, :inverse_of => :user
end
