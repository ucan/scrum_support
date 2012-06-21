class UserController < ApplicationController
	def create
		@user = User.new(name: params[:name])
		@user.save
		respond_to do |format|
			format.html { render :show, :user => @user}
			format.json  { render :json; @user.id }
		end
	end

	def show
		@user = User.find(params[:id])
	end

	#testing purposes only!
	def setup
		@user = User.new(name: "Testy McTest")
		@user.save

		ptAccount = PtAccount.new('79fecc5af7fb6eb27462f02be67b2d53')
		ptAccount.save

		@user.accounts << ptAccount
		@user.save

		
	end
end