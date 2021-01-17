class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :short_name
      t.string :full_name

      t.timestamps
    end
  end
end
