require 'spec_helper'

describe User do
  before(:each) do
	@user = FactoryGirl.create(:user)
  end

  it "should be able to add an account" do
	account = Account.new
	@user.accounts.should eql []
	@user.accounts << account
	@user.accounts.should eql [account]
	account.user.should eql @user
  end

  it "should not be able to add a duplicate account" do
	account = Account.new
	@user.accounts.should eql []
	@user.accounts << account
	@user.accounts.should eql [account]
	@user.accounts << account
	@user.accounts.should eql [account]
  end

  subject { @user }
  it { should respond_to(:accounts) }
  it { should respond_to(:email) }
  it { should be_valid }
end
