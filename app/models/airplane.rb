class Airplane < ApplicationRecord
    belongs_to :airline
    has_many :flights, :dependent => :delete_all, :foreign_key => :airplanes_id
end
