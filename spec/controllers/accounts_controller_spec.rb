require 'spec_helper'

describe AccountsController do
  it "should be able to list account ids for a user" do
    user = User.new(name: "Testy Kills")
    user.accounts << Account.new()
    user.accounts << Account.new()
    user.save!

    get :list, { :auth_token => user.authentication_token }

    expected = user.accounts.to_json
    result = ActiveSupport::JSON.decode(response.body)
    ActiveSupport::JSON.decode(expected).should =~ result
  end

  it "can create an account linked to pivotal tracker" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  it "can show the information for a specific account" do
    user = User.new(name: "Testy Kills")
    account = Account.new()
    user.accounts << account
    user.save!

    get :show, {:id => account.id, :auth_token => user.authentication_token }

    expected = account.projects.to_json
    result = ActiveSupport::JSON.decode(response.body)
    ActiveSupport::JSON.decode(expected).should == result
  end

  it "does not allow access to other users accounts" do
  	user1 = User.new(name: "Testy Kills")
    account1 = Account.new()
    user1.accounts << account1
    user1.save!

    user2 = User.new(name: "Testy Killer")
    user2.save!

    get :show, {:id => account1.id, :auth_token => user2.authentication_token }

    response.response_code.should eql 403
    result = ActiveSupport::JSON.decode(response.body)
    result["error"].should_not eql nil
    result["error"].should eql I18n.t('request.forbidden')

  end

end
