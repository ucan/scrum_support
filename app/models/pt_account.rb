class PtAccount < Account
  
  def initialize(email, password)
    super()
  	PivotalTracker::Client.token(email, password)
    fetch_projects
  end

  def fetch_projects
  	projects = []
  	PivotalTracker::Project.all.each { |ptProject|
      ourProject = Project.new(title: ptProject.name)
      mapping = ProjectMapping.new(linked_id: ptProject.id, project: ourProject)
      project_mappings << mapping
      ourProject.save!
      fetch_stories(mapping)
  	}
  	projects
  end

  def fetch_stories(project_mapping)
    PivotalTracker::Project.find(project_mapping.linked_id).stories.all.each do |ptStory|
      ourStory = Story.new(title: ptStory.name, project: project_mapping.project)
      project_mapping.project.stories << ourStory
      ourStory.save!
      fetch_tasks(ptStory ,ourStory)
    end
  end

  def fetch_tasks(ptStory, ourStory)
    ptStory.tasks.all.each do |ptTask|
      ourTask = Task.new(description: ptTask.description, story: ourStory)
      ourStory.tasks << ourTask
      ourTask.save!
    end
  end

end
