@skyscan.each do |sc|
	#json.session sc.pricingsession
	json.itineraries sc.pricingsession["Itineraries"].each do |it|
		json.outboundLegid do
			leg = sc.pricingsession["Legs"].find {|l| l["Id"]==it["OutboundLegId"]}
			json.duration leg["Duration"]
			json.Departure leg["Departure"]
			json.Arrival leg["Arrival"]
			json.JourneyMode leg["JourneyMode"]
			json.Stops leg["Stops"]
			json.Carriers leg["Carriers"]
			json.FlightNumbers leg["FlightNumbers"]
		end
		json.InboundLegid do
			leg = sc.pricingsession["Legs"].find {|l| l["Id"]==it["InboundLegId"]}
			json.duration leg["Duration"]
			json.Departure leg["Departure"]
			json.Arrival leg["Arrival"]
			json.JourneyMode leg["JourneyMode"]
			json.Stops leg["Stops"]
			json.Carriers leg["Carriers"]
			json.FlightNumbers leg["FlightNumbers"]
		end
	end
end