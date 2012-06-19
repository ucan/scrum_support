class Project < ActiveRecord::Base
  attr_accessible :title

  has_many :storys, :uniq => true
  has_many :memberships, :uniq => true

  validates_presence_of :title

  def initialize(attributes = {})
  	super
    @title = attributes[:title]

    # PivotalTracker::Client.token = '79fecc5af7fb6eb27462f02be67b2d53'
    # projects = PivotalTracker::Project.all.each { |project| 
    #   puts "Project name: #{project.name} id: #{project.id}"
    #   membership = PivotalTracker::Membership.all(project).each { |member| 
    #     puts "  Member name: #{member.name} Role: #{member.role}"
    #   }
    #   puts
    #   stories = PivotalTracker::Story.all(project).each { |story|
    #     puts "  Story name: #{story.name} id: #{story.id}"
    #     tasks = PivotalTracker::Task.all(story).each { |task| 
    #       puts "    Task description: #{task.description} id: #{task.id}"
    #     }
    #   }
    #   puts
    # }
  end

  def to_s
  	@title
  end

end
