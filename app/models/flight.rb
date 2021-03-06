class Flight < ApplicationRecord
    belongs_to :city
    belongs_to :airplane
    validates :flight_no, :presence => true
    validate do |flight|
        errors.add("Arrival and Departure times are messed up") if flight.arrival < flight.departure
        errors.add("Source and Destination should not be the same...") if flight.source == flight.destination
    end
    @@page_size = 5

    def self.find_two_way_flights_with_params(params)
        query_string = " flights.source = ? AND flights.destination = ? AND flights.departure >= ? AND f1.arrival <= ? AND f1.departure > flights.arrival AND flights.seats >= ? AND f1.seats >= ?"
        query_args = [params[:source].to_i,params[:destination].to_i,DateTime.parse(params[:departure]),DateTime.parse(params[:return]),params[:passenger_count],params[:passenger_count]]
        if(params.has_key?(:price_low))
            query_string += " AND flights.cost+f1.cost >= ?"
            query_args.push(params[:price_low])
        end
        if(params.has_key?(:price_high))
            query_string += " AND flights.cost+f1.cost <= ?"
            query_args.push(params[:price_high])
        end
        flight_data = Flight.select("flights.*,f1.flight_no as return_flight, f1.cost as return_cost,
            f1.departure as return_departure, f1.arrival as return_arrival, f1.cost as return_cost,
            f1.airplanes_id as airplanes_id")
        .joins("inner join flights f1 on flights.destination = f1.source AND f1.destination = flights.source").where(query_string,*query_args)
        .order("flights.cost+f1.cost asc, flights.departure asc, f1.departure asc")
        return {:flights => flight_data.limit(@@page_size).offset((params[:page]-1) * @@page_size), :count => flight_data.length }
    end

    def self.compile_query_string(params)
        query_string = ""
        query_args = []
        
        query_set = false
        if params.has_key?(:source)
            query_string = " source = ?"
            query_args.push(params[:source].to_i)
            query_set = true
        end
        if(params.has_key?(:price_high))
            query_string += ( (query_set)? " AND" : "" ) + " cost <= ?"
            query_set = true
            query_args.push(params[:price_high])
        end
        if(params.has_key?(:price_low))
            query_string += ( (query_set)? " AND" : "" ) + " cost >= ?"
            query_set = true
            query_args.push(params[:price_low])
        end
        if params.has_key?(:destination)
            query_string += ( (query_set)? " AND" : "" ) + " destination = ?"
            query_args.push(params[:destination].to_i)
            query_set = true
        end
        if params.has_key?(:passenger_count)
            query_string += ( (query_set)? " AND" : "" ) + " seats >= ?"
            query_args.push(params[:passenger_count])
            query_set = true
        end
        if params.has_key?(:departure)
            query_string += ( (query_set)? " AND" : "" ) + " departure >= ?"
            query_args.push(DateTime.parse(params[:departure]))
            query_set = true
        end
        return {:query_string => query_string, :query_args => query_args}
    end

    def self.find_flights_with_params(params)
        query_data = Flight.compile_query_string(params)
        results = Flight.where(query_data[:query_string],*query_data[:query_args]).order("flights.cost asc, flights.departure asc")
        return {:flights => results.limit(@@page_size).offset((params[:page]-1) * @@page_size), :count => results.length }
    end
end
