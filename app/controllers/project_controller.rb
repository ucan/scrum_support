class ProjectController < ApplicationController
	def list

		puts "Params = #{params.inspect}"

		user = User.find(params[:userid])
		@projects = []
		user.accounts.each { |account|
		  account.projects.each { |project| 
		  	@projects << project
		  }
		}
		respond_to do |format|
			format.html # projects.html.erb
			format.json  { render :json; @projects.to_json }
		end
	end

	def show
		@project = Project.find(params[:id])
		respond_to do |format|
			format.html
			format.json  { render :json; @project.to_json }
		end
	end
end
