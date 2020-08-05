# frozen_string_literal: true

# Description/Explanation of Person class
class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :name
      t.integer :company_id
      t.string :level
      t.string :experience
      t.string :salary
      t.datetime :create_date
      t.datetime :expiration_date
      t.text :description
      t.timestamps
    end
  end
end
