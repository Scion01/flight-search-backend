class AddCostToFlights < ActiveRecord::Migration[5.2]
  def change
    add_column :flights, :cost, :integer, :null => false, :default => 1200
  end
end
