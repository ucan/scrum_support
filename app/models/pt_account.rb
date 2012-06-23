class PtAccount < Account
  
  def initialize(token)
    super()
  	PivotalTracker::Client.token = token
    fetch_projects
  end

  # def initialize(username, password)
  # 	PivotalTracker::Client.token(username, token)
  # end

  def fetch_projects
  	projects = []
  	PivotalTracker::Project.all.each { |ptProject|
      ourProject = Project.new(title: ptProject.name)
      mapping = ProjectMapping.new(linked_id: ptProject.id, project: ourProject)
      mapping.save
      ourProject.save
      project_mappings << mapping


      ptProject.stories.all.each do |ptStory|
        ourStory = Story.new(title: ptStory.name, project: ourProject)
        ourProject.stories << ourStory
        ourStory.save

        ptStory.tasks.all.each do |ptTask|
          ourTask = Task.new(description: ptTask.description, story: ourStory)
          ourStory.tasks << ourTask
          ourTask.save
        end
      end
      ourProject.save
  	}
  	projects
  end
end
