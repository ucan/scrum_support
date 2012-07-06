class PtAccount < Account

# TODO Need to add begin/rescue to each fetch method of this class, 
# to handle 502/503 responses from PT server

  attr_accessible :api_token

  validates_presence_of :api_token, :on => :create
  validates_uniqueness_of :api_token
  
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
        existing_membership = project.memberships.detect { |m| m.team_member.email == ptMembership.email }
        if existing_membership
          team_member = existing_membership.team_member
          update_membership(existing_membership, ptMembership)
          temp_memberships << existing_membership
        else
          team_member = TeamMember.where(email: ptMembership.email).first
          if team_member.nil?
            team_member = TeamMember.new(name: ptMembership.name, email: ptMembership.email)
          end
          temp_memberships << Membership.new(team_member: team_member, project: external_project_link.project)
        end
        if team_member && self.email == team_member.email
          self.team_member = team_member
          self.save
        else
          puts "did not find teammember for #{self.email}"
          # TODO inform user to check/change their email?
        end
      end
      project.memberships = temp_memberships
      
      me = TeamMember.where(email: self.email).first
    else
      # error handling...not found? not authorized?
    end  
  end

  def fetch_stories(project)
    # project.stories = []
    temp_story_links = []
    external_project_link = self.external_project_links.detect { |pm| pm.project == project }
    if external_project_link
      PivotalTracker::Client.token = self.api_token
      PivotalTracker::Project.find(external_project_link.linked_id).stories.all.each do |ptStory|
        existing_link = external_project_link.external_story_links.detect { |esl| esl.linked_id == ptStory.id }
        if existing_link
          update_story(existing_link.story, ptStory)
          temp_story_links << existing_link
        else
          ourStory = Story.new(title: ptStory.name, project: external_project_link.project)
          new_link = ExternalStoryLink.new(linked_id: ptStory.id, story: ourStory)
          temp_story_links << new_link
        end        
      end
      external_project_link.external_story_links = temp_story_links
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
    membership.team_member.name = ptMembership.name
  end

  def update_story(story, ptStory)
    story.title = ptStory.name
  end

  def update_task(task, ptTask)
    task.description = ptTask.description
    #task.complete if ptTask.complete? # TODO hmm...
  end

end
