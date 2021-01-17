class City < ApplicationRecord
    has_many  :sources, :class_name => 'Flight', :dependent => :delete_all, :foreign_key => "source"
    has_many  :destinations, :class_name => 'Flight', :dependent => :delete_all, :foreign_key => "destination"
    validates :short_name, :presence => true
    validates :full_name, :presence => true
end
