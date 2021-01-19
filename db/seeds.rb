# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'securerandom'


cities = [
    {
        :short_name => "BLR",
        :full_name => "BENGALURU"
    },
    {
        :short_name => "DEL",
        :full_name => "DELHI"
    },
    {
        :short_name => "PNQ",
        :full_name => "PUNE"
    },
    {
        :short_name => "MAA",
        :full_name => "CHENNAI"
    },
    {
        :short_name => "CCU",
        :full_name => "KOLKATA"
    },
    {
        :short_name => "NAG",
        :full_name => "NAGPUR"
    },
    {
        :short_name => "LKO",
        :full_name => "LUCKNOW"
    },
    {
        :short_name => "IDR",
        :full_name => "INDORE"
    },
    {
        :short_name => "JAI",
        :full_name => "JAIPUR"
    }
]

airlines = [
    {
        :name => "SpiceJect",
        :logo_url => "https://cdn2.vectorstock.com/i/1000x1000/19/86/aircraft-airplane-airline-logo-or-label-journey-vector-21441986.jpg"
    },
    {
        :name => "Inddigo",
        :logo_url => "https://cdn2.vectorstock.com/i/1000x1000/19/86/aircraft-airplane-airline-logo-or-label-journey-vector-21441986.jpg"
    },
    {
        :name => "Air Indiaa",
        :logo_url => "https://cdn2.vectorstock.com/i/1000x1000/19/86/aircraft-airplane-airline-logo-or-label-journey-vector-21441986.jpg"
    },
    {
        :name => "Kingfished",
        :logo_url => "https://cdn2.vectorstock.com/i/1000x1000/19/86/aircraft-airplane-airline-logo-or-label-journey-vector-21441986.jpg"
    },
    {
        :name => "Asia Air",
        :logo_url => "https://cdn2.vectorstock.com/i/1000x1000/19/86/aircraft-airplane-airline-logo-or-label-journey-vector-21441986.jpg"
    }
]

airplanes = [
    {
        :model => "2A123",
        :tail_number => SecureRandom.hex(5)
    },
    {
        :model => "2A123",
        :tail_number => SecureRandom.hex(5)
    },
    {
        :model => "2A124",
        :tail_number => SecureRandom.hex(5)
    }
]

Rails.logger.debug("Seeding cities...")

cities.each do |city|
    City.create(city)
end

Rails.logger.debug("Seeding airlines...")

airlines.each do |airline|
     Airline.create(airline)
end


airline_count = Airline.count
iter = 0

Rails.logger.debug("Seeding airplanes...")

airplanes.each do |airplane|
    airplane[:airlines_id] =  Airline.limit(1).offset(iter)[0].id
    Airplane.create(airplane)
    iter =(iter+1) % airline_count
end


def rand_departure_time(from, to=Time.now)
    Time.at(rand_in_range(from.to_f, to.to_f))
end

def rand_in_range(from, to)
    rand * (to - from) + from
end

def arrival_offset()
    rand_in_range(1, 6).to_i
end

def get_rand_in_range(low,high)
    rand_in_range(low,high).to_i
end

all_cities_count = City.all.count
all_cities = City.all.pluck(:id)

# Airplane.all.each do |airplane|
#     20.times{
#         departure = rand_departure_time(get_rand_in_range(1,30).days.from_now)
#         arrival = departure + arrival_offset().hours
#         source = all_cities[get_rand_in_range(0,all_cities_count)]
#         destination = all_cities[(source + 1) % all_cities_count]
#         Flight.create(:flight_no => SecureRandom.hex(5), :departure => departure, :arrival => arrival, :seats => get_rand_in_range(40,80), 
#         :source => source, :destination => destination, :airplanes_id => airplane.id )
#         #forcefully add a return journey for each source and dest
#         departure = arrival + get_rand_in_range(1,5).days + get_rand_in_range(1,7).hours
#         arrival = departure + arrival_offset().hours
#         Flight.create(:flight_no => SecureRandom.hex(5), :departure => departure , :arrival => arrival, :seats => get_rand_in_range(40,80), 
#         :source => destination, :destination => source, :airplanes_id => airplane.id )
#     }
# end

#the above random way of generating flights was a mistake....

unique_pairs = all_cities.combination(2).to_a
Airplane.all.each do |airplane|
    unique_pairs.each do |city_pair|
        get_rand_in_range(1,3).times{
            departure = rand_departure_time(get_rand_in_range(1,30).days.from_now)
            arrival = departure + arrival_offset().hours
            source = city_pair[0]
            destination = city_pair[1]
            Flight.create(:flight_no => SecureRandom.hex(5), :departure => departure, :arrival => arrival, :seats => get_rand_in_range(40,80), 
            :source => source, :destination => destination, :airplanes_id => airplane.id, :cost => get_rand_in_range(1200,4000) )
            #forcefully add a return journey for each source and dest
            departure = arrival + get_rand_in_range(0,2).days + get_rand_in_range(1,7).hours
            arrival = departure + arrival_offset().hours
            Flight.create(:flight_no => SecureRandom.hex(5), :departure => departure , :arrival => arrival, :seats => get_rand_in_range(40,80), 
            :source => destination, :destination => source, :airplanes_id => airplane.id, :cost => get_rand_in_range(1200,4000) )
        }
    end
end