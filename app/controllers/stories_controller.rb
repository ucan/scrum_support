class StoriesController < ApplicationController
	
	# before_filter :authenticate_user!

	

	def show
		@story = Story.find(params[:id])
		
		# respond_to do |format|
		# 	format.html
		# 	format.json  { render :json; @story.to_json }
		# end
	end

	def list_for_project
		project = Project.find(params[:id])
		@storys = project.storys
		
		# respond_to do |format|
		# 	format.html {render :list, :storys => @storys}
		# 	format.json  { render :json; @storys }
		# end
	end
end
