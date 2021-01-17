class AddUniqConstraints < ActiveRecord::Migration[5.2]
  def change
    add_index :cities, [:short_name, :full_name], :unique => true
    add_index :airlines, [:name], :unique => true
    add_index :airplanes, [:tail_number], :unique => true
    add_index :flights, [:flight_no], :unique => true
    add_index :flights, [:source, :destination]
  end
end
