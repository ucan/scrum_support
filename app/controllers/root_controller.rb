class RootController < ApplicationController

	def index
		links = {links: {user: "/user"}}

		render json: links
	end
end
