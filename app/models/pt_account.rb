class PtAccount < Account

# TODO Need to add begin/rescue to each fetch method of this class, 
# to handle 502/503 responses from PT server

  attr_accessible :api_token

  validates_presence_of :api_token, :on => :create
  
  # Retrieve a users api_token from PT using email and password
  def self.get_token(email, password)
    PivotalTracker::Client.token(email, password)
  end

  def fetch_projects
    PivotalTracker::Client.token = self.api_token
  	PivotalTracker::Project.all.each do |ptProject|
      existing_mapping = ExternalProjectLink.where(linked_id: ptProject.id).first #self.external_project_links.detect { |pm| pm.linked_id == ptProject.id }
      if existing_mapping
        update_project(existing_mapping.project, ptProject)
        self.external_project_links << existing_mapping
      else        
        ourProject = Project.new(title: ptProject.name)
        mapping = ExternalProjectLink.new(linked_id: ptProject.id, project: ourProject)
        mapping.accounts << self
        mapping.save!
      end
  	end
  end

  def fetch_members(project)
    temp_memberships = []
    external_project_link = self.external_project_links.detect { |pm| pm.project == project }
    if external_project_link      
      PivotalTracker::Client.token = self.api_token
      PivotalTracker::Project.find(external_project_link.linked_id).memberships.all.each do |ptMembership|
        existing_membership = project.memberships.detect { |m| m.person.email == ptMembership.email }
        if existing_membership
          update_membership(existing_membership, ptMembership)
          temp_memberships << existing_membership
        else
          person = Person.where(email: ptMembership.email).first
          if person.nil?
            person = Person.new(name: ptMembership.name, email: ptMembership.email)
          end
          temp_memberships << Membership.new(person: person, project: external_project_link.project)
        end
      end
      project.memberships = temp_memberships
    else
      # error handling...not found? not authorized?
    end  
  end

  def fetch_stories(project)
    # project.stories = []
    temp_story_mappings = []
    external_project_link = self.external_project_links.detect { |pm| pm.project == project }
    if external_project_link
      PivotalTracker::Client.token = self.api_token
      PivotalTracker::Project.find(external_project_link.linked_id).stories.all.each do |ptStory|
        existing_mapping = external_project_link.story_mappings.detect { |sm| sm.linked_id == ptStory.id }
        if existing_mapping
          update_story(existing_mapping.story, ptStory)
          temp_story_mappings << existing_mapping
        else
          ourStory = Story.new(title: ptStory.name, project: external_project_link.project)
          new_mapping = StoryMapping.new(linked_id: ptStory.id, story: ourStory)
          temp_story_mappings << new_mapping
        end        
      end
      external_project_link.story_mappings = temp_story_mappings
    else
      # error handling
    end
  end

  def fetch_tasks(story)
    temp_task_mappings = []    
    PivotalTracker::Client.token = self.api_token
    external_project_link = self.external_project_links.detect { |pm| pm.project == story.project }
    story_mapping = external_project_link.story_mappings.detect { |sm| sm.story == story }
    if story_mapping && external_project_link
      PivotalTracker::Story.find(story_mapping.linked_id, external_project_link.linked_id).tasks.all.each do |ptTask|
        existing_mapping = story_mapping.task_mappings.detect { |tm| tm.linked_id == ptTask.id }
        if existing_mapping
          update_task(existing_mapping.task, ptTask)
          temp_task_mappings << existing_mapping
        else
          ourTask = Task.new(description: ptTask.description, story: story_mapping.story)
          temp_task_mappings << TaskMapping.new(linked_id: ptTask.id, task: ourTask)
        end      
      end   
      story_mapping.task_mappings = temp_task_mappings   
    else
      # error handling
    end
  end

  protected

  # Following update methods used by fetch methods to update our
  # existing database rows in case of modifications coming from PT

  def update_project(project, ptProject)
    project.title = ptProject.name
  end

  def update_membership(membership, ptMembership)
    membership.person.name = ptMembership.name
  end

  def update_story(story, ptStory)
    story.title = ptStory.name
  end

  def update_task(task, ptTask)
    task.description = ptTask.description
    #task.complete if ptTask.complete? # TODO hmm...
  end

end
