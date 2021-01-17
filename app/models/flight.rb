class Flight < ApplicationRecord
    belongs_to :city
    belongs_to :airplane
    validates :flight_no, :presence => true
end
