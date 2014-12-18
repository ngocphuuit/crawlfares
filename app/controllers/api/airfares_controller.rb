class Api::AirfaresController < ApplicationController

	require 'net/http'
	require 'uri'

	TOKEN = "prtl6749387986743898559646983194"

	def index
		@airfares = Fare.all
	end

	def airfare
		@airfares = Fare.all
	end

	def skyscanner
		@skyscan = Skyscan.all
	end

	def create_skyscanner
		@departure = ['IAH', 'DFW', 'AUS', 'ORD', 'NYC', 'LAX', 'SFO', 'SEA', 'ATL', 'MIA', 'BOS', 'LAS']
		@destination = ['HAN', 'SGN', 'SIN', 'BKK', 'PEK', 'PVG', 'KUL', 'NRT', 'ICN', 'TPE']
		@departure.each do |departure|
			@destination.each do |destination|
				search_skyscanner(departure, destination)
			end
		end
	end


	private

		def search_skyscanner(departure, destination)
			uri = URI.parse('http://business.skyscanner.net/apiservices/pricing/v1.0/?apikey=prtl6749387986743898559646983194')
			request = Net::HTTP::Post.new(uri.request_uri)
			data = {
				country: "UK",
				currency: "GBP",
				locale: "en-GB",
				locationSchema: "iata",
				originplace: departure,
				destinationplace: destination,
				outbounddate: "2014-12-24",
				inbounddate: "2014-12-31",
				adults: 1,
				children: 0,
				infants: 0,
				cabinclass: "Economy"
			}
			request.set_form_data(data)
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
				http.request(request)
			end
			if res.code == "201"
				@location = res['Location']
				sleep(20)
				pricingsession(@location)
			end
			# Skyscanner::Connection.apikey = TOKEN
			# @result = Skyscanner::Connection.browse_routes({
			# 		:country => "GB",
			# 		:currency => "GBP",
			# 		:locale => "en-GB",
			# 		:originPlace => "LGW",
			# 		:destinationPlace => "SGN",
			# 		:outboundPartialDate => "2014-12-25",
			# 		:inboundPartialDate => "2014-12-30"
			# 		# country:"UK",
			# 		# currency:"GBP",
			# 		# locale:"en-GB",
			# 		# locationSchema:"iata",
			# 		# originplace:"EDI",
			# 		# destinationplace:"LHR",
			# 		# outbounddate:"2014-12-24",
			# 		# inbounddate:"2014-12-31",
			# 		# adults:1,
			# 		# children:0,
			# 		# infants:0,
			# 		# cabinclass:"Economy"
			# 	})

			# puts "============="
			# puts @result
			# # puts "============="
			# respond_to do |format|
			# 	format.html
			# 	format.json {render json: @location}
			# end
			# conn = Faraday.new(:url => 'http://business.skyscanner.net/apiservices/pricing/v1.0/?apikey=prtl6749387986743898559646983194') do |faraday|
			# 	faraday.request :url_encoded
			# 	faraday.response :logger
			# 	faraday.adapter Faraday.default_adapter
			# end

			# conn.post '', {
			# 	:country => "UK",
			# 	:currency => "GBP",
			# 	:locale => "en-GB",
			# 	:locationSchema => "iata",
			# 	:originplace => "EDI",
			# 	:destinationplace => "LHR",
			# 	:outbounddate => "2014-12-24",
			# 	:inbounddate => "2014-12-31",
			# 	:adults => 1,
			# 	:children => 0,
			# 	:infants => 0,
			# 	:cabinclass => "Economy"
			# }
		end

		def pricingsession(uri)
			# puts uri+"?apikey=prtl6749387986743898559646983194"
			uri = URI.parse(uri+"?apikey=prtl6749387986743898559646983194")
			request = Net::HTTP::Get.new(uri.request_uri)
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
				http.request(request)
			end
			if res.code == "200"
				hash = ActiveSupport::JSON.decode(res.body)
				Skyscan.create(pricingsession: hash)
			end
		end


end