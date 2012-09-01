require 'spec_helper'

describe ProjectsController do

  include ActionController::HttpAuthentication::Token

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
    external_project_link1 = FactoryGirl.create(:external_project_link, project: project1)
    account1 = external_project_link1.accounts[0]
    user = account1.user

    account2 = FactoryGirl.create(:account, user: user)
    project2 = FactoryGirl.create(:project)
    external_project_link2 = FactoryGirl.create(:external_project_link, project: project2)
    external_project_link2.accounts << account2

    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    get :list
    result = ActiveSupport::JSON.decode(response.body)
    result["projects"].should =~ ActiveSupport::JSON.decode([project1, project2].to_json)
  end

  it "should return a list of stories for a project" do
    project = FactoryGirl.create(:project)
    external_project_link = FactoryGirl.create(:external_project_link, project: project)

    user = external_project_link.accounts[0].user
    project.stories << FactoryGirl.create(:story)
    project.stories << FactoryGirl.create(:story)

    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    get :show, {id: project.id }
    result = ActiveSupport::JSON.decode(response.body)
    result["stories"].should =~ ActiveSupport::JSON.decode(project.stories.to_json)
  end

  it "should return a list of members for a project" do
    project = FactoryGirl.create(:project)
    external_project_link = FactoryGirl.create(:external_project_link, project: project)
    user = external_project_link.accounts[0].user
    project.team_members << FactoryGirl.create(:team_member)
    project.team_members << FactoryGirl.create(:team_member)

    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    get :show, {id: project.id }
    result = ActiveSupport::JSON.decode(response.body)

    result["stories"].should =~ ActiveSupport::JSON.decode(project.stories.to_json)
  end

  it "should provide an error if the project id is not valid" do
    user = FactoryGirl.create :user
    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(user.auth_token)
    get :show, { id: 999999 }
    result = ActiveSupport::JSON.decode response.body
    response.status.should eql 404
    result["error"].should eql I18n.t 'request.not_found'
  end

  it "should only allow access to the authenticated users stories" do
    story = FactoryGirl.create :story
    project = story.project
    external_project_link = FactoryGirl.create(:external_project_link, project: project)

    different_user = FactoryGirl.create :user

    @request.env["HTTP_AUTHORIZATION"] = encode_credentials(different_user.auth_token)
    get :show, {id: project.id }
    result = ActiveSupport::JSON.decode(response.body)
    result["error"].should_not eql nil
    result["error"].should eql I18n.t('request.forbidden')
  end
end
