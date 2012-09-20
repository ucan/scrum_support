class PtAccount < Account

  # TODO Need to add begin/rescue to each fetch method of this class,
  # to handle 502/503 responses from PT server

  attr_accessible :api_token

  validates_presence_of :api_token, on: :create
  validates_uniqueness_of :api_token

  # Retrieve a users api_token from PT using email and password
  def self.get_token(email, password)
    PivotalTracker::Client.token(email, password)
  end

  def fetch_projects # TODO this also fetches members...may as well use that?
    PivotalTracker::Client.token = self.api_token
    PivotalTracker::Project.all.each do |ptProject|
      existing_link = ExternalProjectLink.where(linked_id: ptProject.id).first #self.external_project_links.detect { |pm| pm.linked_id == ptProject.id }
      if existing_link
        update_project(existing_link.project, ptProject)
        self.external_project_links << existing_link
      else
        ourProject = Project.new(title: ptProject.name, current_iteration_id: ptProject.current_iteration_number)
        link = ExternalProjectLink.new(linked_id: ptProject.id, project: ourProject)
        link.accounts << self
        link.save!
      end
    end
  end

  # Fetches all iterations/stories/tasks from PT
  def fetch_iterations(project)
    PivotalTracker::Client.token = self.api_token
    epl = ExternalProjectLink.where(project_id: project.id).first
    if epl
      ptProject = PivotalTracker::Project.find(epl.linked_id)
      update_project(project, ptProject)
      if ptProject
        PivotalTracker::Iteration.all(ptProject).each do |ptIteration|
          existing_link = epl.external_iteration_links.where(linked_id: ptIteration.id).first # ExternalIterationLink.where(linked_id: ptIteration.id).first
          if existing_link
            update_iteration(existing_link.iteration, ptIteration)
            epl.external_iteration_links << existing_link
            create_stories(existing_link, ptIteration)
          else
            ourIteration = Iteration.new(project: project)
            new_link = ExternalIterationLink.new(linked_id: ptIteration.id, iteration: ourIteration)
            epl.external_iteration_links << new_link
            create_stories(new_link, ptIteration)
            new_link.save!
          end
        end
      end
    end
  end

  def fetch_members(project) ## TODO change this to update_project
    temp_memberships = []
    external_project_link = self.external_project_links.detect { |pm| pm.project == project }
    if external_project_link
      PivotalTracker::Client.token = self.api_token
      PivotalTracker::Project.find(external_project_link.linked_id).memberships.all.each do |ptMembership|
        existing_membership = project.memberships.detect { |m| m.team_member.email == ptMembership.email }
        currentMember = nil
        if existing_membership
          currentMember = existing_membership.team_member
          update_membership(existing_membership, ptMembership)
          temp_memberships << existing_membership
        else
          currentMember = TeamMember.where(email: ptMembership.email).first
          if currentMember.nil?
            currentMember = TeamMember.new(name: ptMembership.name, email: ptMembership.email)
          end
          temp_memberships << Membership.new(team_member: currentMember, project: external_project_link.project)
        end
        if currentMember && self.email == currentMember.email
          self.team_member = currentMember
          self.save
        end
      end
      project.memberships = temp_memberships

      # me = TeamMember.where(email: self.email).first
    else
      # error handling...not found? not authorized?

      if self.team_member.nil?
        print "No team member found for #{self.email}"
      end

    end
  end

  def fetch_stories(iteration) ## TODO !!!!!!!!!!!!!!!!!!
    fetch_iterations(iteration.project)
  end

  def fetch_tasks(story)
    PivotalTracker::Client.token = self.api_token
    epl = ExternalProjectLink.where(project_id: story.iteration.project.id).first
    esl = ExternalStoryLink.where(story_id: story).first
    if epl && esl
      ptStory = PivotalTracker::Story.find(esl.linked_id, epl.linked_id)
      if ptStory
        create_tasks(esl, ptStory)
      end
    end
    # temp_task_links = []
    # PivotalTracker::Client.token = self.api_token
    # external_project_link = self.external_project_links.detect { |epl| epl.project == story.project }
    # external_story_link = external_project_link.external_story_links.detect { |esl| esl.story == story }
    # if external_story_link && external_project_link
    #   PivotalTracker::Story.find(external_story_link.linked_id, external_project_link.linked_id).tasks.all.each do |ptTask|
    #     existing_link = external_story_link.external_task_links.detect { |etl| etl.linked_id == ptTask.id }
    #     if existing_link
    #       update_task(existing_link.task, ptTask)
    #       temp_task_links << existing_link
    #     else
    #       ourTask = Task.new(description: ptTask.description, story: external_story_link.story)
    #       temp_task_links << ExternalTaskLink.new(linked_id: ptTask.id, task: ourTask)
    #     end
    #   end
    #   external_story_link.external_task_links = temp_task_links
    # else
    #   # error handling
    # end
  end

  protected

  # Following update methods used by fetch methods to update our
  # existing database rows in case of modifications coming from PT

  def update_project(project, ptProject)
    project.title = ptProject.name
    project.current_iteration_id = ptProject.current_iteration_number
    project.save
  end

  def update_iteration(iteration, ptIteration)

  end

  def update_membership(membership, ptMembership)
    membership.team_member.name = ptMembership.name
    membership.team_member.save
  end

  def update_story(story, ptStory)
    story.title = ptStory.name
    story.save
  end

  def update_task(task, ptTask)
    task.description = ptTask.description
    #task.complete if ptTask.complete? # TODO hmm...
    task.save
  end

  # Creates (or updates) a local rep of a PtStory
  def create_stories(eil, ptIteration)
    ptIteration.stories.each do |ptStory|
      existing_link = eil.external_story_links.where(linked_id: ptStory.id).first #ExternalStoryLink.where(linked_id: ptStory.id).first
      if existing_link
        update_story(existing_link.story, ptStory)
        eil.external_story_links << existing_link
        #create_tasks(existing_link, ptStory) # too slow...
      else
        ourStory = Story.new(title: ptStory.name, iteration: eil.iteration)
        new_link = ExternalStoryLink.new(linked_id: ptStory.id, story: ourStory)
        eil.external_story_links << new_link
        #create_tasks(new_link, ptStory)  # too slow...
      end
      eil.save
    end
  end

  def create_tasks(esl, ptStory)
    ptStory.tasks.all.each do |ptTask|
      existing_link = esl.external_task_links.where(linked_id: ptTask.id).first #ExternalTaskLink.where(linked_id: ptTask.id).first
      if existing_link
        update_task(existing_link.task, ptTask)
        esl.external_task_links << existing_link
      else
        ourTask = Task.new(description: ptTask.description, story: esl.story)
        esl.external_task_links << ExternalTaskLink.new(linked_id: ptTask.id, task: ourTask)
      end
      esl.save
    end
  end
end
