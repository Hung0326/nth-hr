# frozen_string_literal: true

# Description/Explanation of Person class
class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.boolean :area
      t.timestamps
    end
  end
end
