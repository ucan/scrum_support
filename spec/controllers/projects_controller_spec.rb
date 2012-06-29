require 'spec_helper'

describe ProjectsController do

  before(:all) do
    # Supress unnecessary methods for controller tests
    a = Account.new
    $old_fetch_projects = a.method(:fetch_projects)
    $old_fetch_members = a.method(:fetch_members)
    $old_fetch_stories = a.method(:fetch_stories)
    class Account
      def fetch_projects
      end
      def fetch_members(project)
      end
      def fetch_stories(project)
      end
    end
  end

  after(:all) do
    # Return back to normal to prevent mucking up future tests
    class Account
      define_method($old_fetch_projects.name, &$old_fetch_projects)
      define_method($old_fetch_members.name, &$old_fetch_members)
      define_method($old_fetch_stories.name, &$old_fetch_stories)
    end
  end

  it "should return all the projects for a user" do
    project1 = FactoryGirl.create(:project)
    projectMapping1 = FactoryGirl.create(:project_mapping, project: project1)
    account1 = projectMapping1.account
    user = account1.user

    account2 = FactoryGirl.create(:account, user: user)
    project2 = FactoryGirl.create(:project)
    projectMapping2 = FactoryGirl.create(:project_mapping, account: account2, project: project2)

    get :list, { :auth_token => user.auth_token }
    result = ActiveSupport::JSON.decode(response.body)
    result["projects"].should =~ ActiveSupport::JSON.decode([project1, project2].to_json)
  end

  it "should return a list of stories for a project" do
    project = FactoryGirl.create(:project)
    projectMapping = FactoryGirl.create(:project_mapping, project: project)
    user = projectMapping.account.user
    project.stories << FactoryGirl.create(:story)
    project.stories << FactoryGirl.create(:story)

    get :show, {:id => project.id, :auth_token => user.auth_token }
    result = ActiveSupport::JSON.decode(response.body)

    result["stories"].should =~ ActiveSupport::JSON.decode(project.stories.to_json)
  end

  it "should return a list of members for a project" do
    project = FactoryGirl.create(:project)
    projectMapping = FactoryGirl.create(:project_mapping, project: project)
    user = projectMapping.account.user
    project.people << FactoryGirl.create(:person)
    project.people << FactoryGirl.create(:person)

    get :show, {:id => project.id, :auth_token => user.auth_token }
    result = ActiveSupport::JSON.decode(response.body)

    result["stories"].should =~ ActiveSupport::JSON.decode(project.stories.to_json)
  end

  it "should provide an error if the project id is not valid" do
    user = FactoryGirl.create :user
    get :show, { :id => 999999, :auth_token => user.auth_token }
    result = ActiveSupport::JSON.decode response.body
    response.status.should eql 404
    result["error"].should eql I18n.t 'request.not_found'
  end

  it "should only allow access to the authenticated users stories" do
    story = FactoryGirl.create :story
    project = story.project

    different_user = FactoryGirl.create :user

    get :show, {:id => project.id, :auth_token => different_user.auth_token }
    result = ActiveSupport::JSON.decode(response.body)
    result["error"].should_not eql nil
    result["error"].should eql I18n.t('request.forbidden')
  end
end

