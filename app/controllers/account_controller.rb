class AccountController < ApplicationController
	def create_pivotal_tracker
		user = User.find(params[:userid])
		token = params[:token]
		@ptAccount = PtAccount.new(token)
		user.accounts << @ptAccount
		user.save

		respond_to do |format|
			format.html
			format.json  { render :json; @ptAccount.id }
		end
	end

	def create_agilefant

	end
end