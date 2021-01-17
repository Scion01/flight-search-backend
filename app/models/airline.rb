class Airline < ApplicationRecord
    validates :name, :presence => true
    has_many :airplanes, :dependent => :destroy, :foreign_key => :airlines_id
    #has_many :flights, :through => :airplanes,  :dependent => :delete_all
end
