class SetReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :airplanes, :airlines, foreign_key: true, index: true
    add_reference :flights, :airplanes, foreign_key: true, index: true
    add_foreign_key :flights, :cities, column: :source
    add_foreign_key :flights, :cities, column: :destination
  end
end
