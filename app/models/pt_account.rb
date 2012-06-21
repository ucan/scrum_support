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
    puts PivotalTracker::Project.all.length
  	PivotalTracker::Project.all.each { |ptProject| 

    ourProject = Project.new(title: ptProject.name)
    mapping = ProjectMapping.new(linked_id: ptProject.id, project: ourProject)
    mapping.save
    ourProject.save
    project_mappings << mapping
      #mapping.save

    #   puts "mapping id = #{mapping.id}"

    #   

  		# projects << ourProject
    #   save
  	}
  	projects
  end
end
