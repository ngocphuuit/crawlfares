class AirfaresController < ApplicationController

	def index
		@airfares = Fare.all
	end

end