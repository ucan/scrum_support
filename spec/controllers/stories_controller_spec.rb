require 'spec_helper'

describe StoriesController do

  include ActionController::HttpAuthentication::Token

  before(:all) do
    # Supress unnecessary methods for controller tests
    a = Account.new
    $old_fetch_tasks = a.method(:fetch_tasks)
    class Account 
      def fetch_tasks(story)
      end
    end
  end

  after(:all) do
    # Return back to normal to prevent mucking up future tests
    class Account
      define_method($old_fetch_tasks.name, &$old_fetch_tasks)
    end
  end
  
  it "should allow a user to retrieve a list of tasks for one of their stories" do
    external_project_link = FactoryGirl.create(:external_project_link)
    story = FactoryGirl.create(:story, project: external_project_link.project)
    FactoryGirl.create(:task, story: story)
    user = ExternalProjectLink.where(project_id: story.project.id).first.account.user

    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    get :show, {:id => story.id }

    result = ActiveSupport::JSON.decode(response.body)
    result["tasks"].should =~ ActiveSupport::JSON.decode(story.tasks.to_json)
  end

  it "handles and id that is not associated with a story" do
    user = FactoryGirl.create :user

    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    get :show, { :id => 1 }

    result = ActiveSupport::JSON.decode(response.body)
    response.status.should eql 404
    result["error"].should eql "Requested resource cannot be found"

  end
end
