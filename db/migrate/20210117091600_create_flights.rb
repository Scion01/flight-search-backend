class CreateFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :flights do |t|
      t.string :flight_no
      t.datetime :arrival
      t.datetime :departure
      t.integer :source
      t.integer :destination
      t.integer :seats

      t.timestamps
    end
  end
end
