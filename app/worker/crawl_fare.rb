class CrawlFare
	include Sidekiq::Worker
	include Sidetiq::Schedulable

	require 'net/http'
	require 'uri'
	# @departure = ['IAH', 'DFW', 'AUS', 'ORD', 'NYC', 'LAX', 'SFO', 'SEA', 'ATL', 'MIA', 'BOS', 'LAS']
	# @destination = ['HAN', 'SGN', 'SIN', 'BKK', 'PEK', 'PVG', 'KUL', 'NRT', 'ICN', 'TPE']
	# recurrence { daily(1).hour_of_day(4, 12, 20) }
	# recurrence { minutely(1) }
	recurrence { hourly.minute_of_hour(13) }

	def perform
		@departure = ['IAH', 'DFW', 'AUS', 'ORD', 'NYC', 'LAX', 'SFO', 'SEA', 'ATL', 'MIA', 'BOS', 'LAS']
		@destination = ['HAN', 'SGN', 'SIN', 'BKK', 'PEK', 'PVG', 'KUL', 'NRT', 'ICN', 'TPE']
		@departure.each do |departure|
			@destination.each do |destination|
				search(departure, destination, "2014-12-17", "2014-12-25")
			end
		end
	end

	def search(departure_code, arrival_code, outbound_date, inbound_date)
		uri = URI('http://api.wego.com/flights/api/k/2/searches?api_key=56013c650c97f5366742&ts_code=3cd74')
		request = Net::HTTP::Post.new(uri)
		data = {
			trips: [{
				departure_code: departure_code,
				arrival_code: arrival_code,
				outbound_date: outbound_date,
				inbound_date: inbound_date
			}],
			adults_count: 1,
			children_count: 1,
			cabin: "economy"
		}
		request.body = data.to_json
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			http.request(request)
		end
		if res.code == "200"
			hash = ActiveSupport::JSON.decode(res.body)
				if hash["trips"].any?
					fare = Fare.create(search: hash)
					getfares(hash["id"], hash["trips"][0]["id"], fare)
				end
		end
	end

	def getfares(search_id, trip_id, fare)
		uri = URI('http://api.wego.com/flights/api/k/2/fares?api_key=56013c650c97f5366742&ts_code=3cd74')
		request = Net::HTTP::Post.new(uri)
		data = {
			id: SecureRandom.base64(13),
			search_id: search_id,
			trip_id: trip_id,
			fares_query_type: "route"
		}
		request.body = data.to_json
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			http.request(request)
		end
		hash = ActiveSupport::JSON.decode(res.body)
		# puts hash["query_id"]
		# hash["routes"].each do |route|
		# puts route["id"]
		# end
		# puts hash["routes"][0]["outbound_segments"]
		# puts hash["routes"][0]["inbound_segments"]
		fare.update(detail: hash["routes"]) if res.code == "200"
	end

end