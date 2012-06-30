FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "fred#{n}@testing.com"
    end
    password "password"
  end

  factory :account do
    user
  end

  factory :person do
    sequence :email do |n|
      "fred#{n}@testing.com"
    end
    sequence :name do |n|
      "fred#{n}"
    end
  end

  factory :external_project_link, :class => ExternalProjectLink do
    sequence :linked_id do |n|
      n
    end
    account
    project
  end

  factory :project do
    sequence :title do |n|
      "project#{n}"
    end
  end

  factory :story do
    sequence :title do |n|
      "story#{n}"
    end
    project
  end

  factory :external_story_link, :class => :ExternalStoryLink do
    sequence :linked_id do |n|
      n
    end
    story
    external_project_link
  end

  factory :task do
    sequence :description do |n|
      "task#{n}"
    end
    story
  end

  factory :external_task_link, :class => :ExternalTaskLink do
    sequence :linked_id do |n|
      n
    end
    task
    external_story_link
  end

end

