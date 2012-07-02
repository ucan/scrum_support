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

  factory :api_key do
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

  factory :project_mapping, :class => ProjectMapping do
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
    #project_mapping
    #association :project_mapping, :strategy => :build
  end

  factory :story do
    sequence :title do |n|
      "story#{n}"
    end
    project
  end

  factory :story_mapping, :class => :StoryMapping do
    sequence :linked_id do |n|
      n
    end
    story
    project_mapping
  end

  factory :task do
    sequence :description do |n|
      "task#{n}"
    end
    story
  end

  factory :task_mapping, :class => :TaskMapping do
    sequence :linked_id do |n|
      n
    end
    task
    story_mapping
  end

end

