@airfares.each do |fare|
	json.array!(fare.detail.each) do |dt|
		json.id dt["id"]
		json.fare dt["fares"].each do |fr|
			json.price fr["price"]
		end
		json.outbound dt["outbound_segments"].each do |ob|
			json.departure_code ob["departure_code"]
			json.arrival_code ob["arrival_code"]
		end

		json.inbound dt["inbound_segments"].each do |ib|
			json.departure_code ib["departure_code"]
			json.arrival_code ib["arrival_code"]
		end
	end
end