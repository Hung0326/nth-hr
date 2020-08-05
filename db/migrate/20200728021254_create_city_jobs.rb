# frozen_string_literal: true

# Description/Explanation of Person class
class CreateCityJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :city_jobs do |t|
      t.references :job
      t.references :city
      t.timestamps
    end
  end
end
