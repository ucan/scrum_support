require 'spec_helper'

describe User do
  before(:each) do
	@user = User.new(name: "Testy McTesticles")
  end

  it "should be able to add an account" do
	ptAccount = PtAccount.new('79fecc5af7fb6eb27462f02be67b2d53')
	@user.accounts.should eql []
	@user.accounts << ptAccount
	@user.accounts.should eql [ptAccount]
	ptAccount.user.should eql @user
  end

  it "should not be able to add a duplicate account" do
	ptAccount = PtAccount.new('79fecc5af7fb6eb27462f02be67b2d53')
	@user.accounts.should eql []
	@user.accounts << ptAccount
	@user.accounts.should eql [ptAccount]
	@user.accounts << ptAccount
	@user.accounts.should eql [ptAccount]
  end

  subject { @user }
  it { should respond_to(:accounts) }
  it { should respond_to(:name) }
  it { should be_valid }
end
